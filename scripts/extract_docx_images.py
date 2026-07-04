#!/usr/bin/env python
"""extract_docx_images.py — pull images out of the Word source, WITH context.

The .docm stores images as word/media/imageN.<ext> with meaningless names, but
document.xml embeds each one inline at its real position (via a relationship id
that word/_rels/document.xml.rels maps to the media file). This walks the
document in reading order, tracks the current Investigation heading and the last
question label, and for every embedded image reports:

    order | investigation | nearest-context | rId | media-file

so you can tell which media file is (say) "Investigation 5.7, after (d)". It
writes a manifest and extracts the matching media files at full original
resolution (source fidelity, unlike a PDF crop).

Usage (from repo root; write output to the scratchpad, not the repo):
    # everything, just the manifest:
    uv run --with lxml python scripts/extract_docx_images.py source/iscam4_RJMPFall25.docm "$SCRATCH/imgs"
    # only images whose investigation-context matches a substring, and extract them:
    uv run --with lxml python scripts/extract_docx_images.py source/iscam4_RJMPFall25.docm "$SCRATCH/imgs" --filter "Investigation 5.7"

Manifest is written to <out_dir>/manifest.tsv; extracted media to <out_dir>/.
"""
import argparse
import os
import re
import sys
import zipfile
import xml.etree.ElementTree as ET

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
A = "{http://schemas.openxmlformats.org/drawingml/2006/main}"
R = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"
V = "{urn:schemas-microsoft-com:vml}"
PR = "{http://schemas.openxmlformats.org/package/2006/relationships}"

INV_RE = re.compile(r"Investigation\s+[A-Z0-9]+\.\d+:.*", re.I)
Q_RE = re.compile(r"^\(([a-z]|[ivx]+)\)")  # (a), (b), ... question labels
PRACTICE_RE = re.compile(r"Practice Problem\s+\S+", re.I)


def rid_to_media(z: zipfile.ZipFile) -> dict:
    rels = ET.fromstring(z.read("word/_rels/document.xml.rels"))
    out = {}
    for rel in rels.findall(PR + "Relationship"):
        if "image" in rel.get("Type", ""):
            target = rel.get("Target")  # e.g. media/image45.png
            out[rel.get("Id")] = "word/" + target.lstrip("/")
    return out


def para_text(p) -> str:
    return "".join(t.text or "" for t in p.iter(W + "t")).strip()


def embeds_in(p):
    """Yield rIds of images embedded in this paragraph, in order (DrawingML + VML)."""
    for blip in p.iter(A + "blip"):
        rid = blip.get(R + "embed") or blip.get(R + "link")
        if rid:
            yield rid
    for img in p.iter(V + "imagedata"):
        rid = img.get(R + "id")
        if rid:
            yield rid


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("docm")
    ap.add_argument("out_dir")
    ap.add_argument("--filter", default=None, help="only rows whose investigation contains this substring")
    args = ap.parse_args()
    os.makedirs(args.out_dir, exist_ok=True)

    with zipfile.ZipFile(args.docm) as z:
        rmap = rid_to_media(z)
        body = ET.fromstring(z.read("word/document.xml")).find(W + "body")

        rows = []
        cur_inv = "(front matter)"
        last_ctx = ""
        for p in body.iter(W + "p"):
            txt = para_text(p)
            if txt:
                if INV_RE.match(txt):
                    cur_inv = txt[:70]
                if Q_RE.match(txt) or PRACTICE_RE.match(txt):
                    last_ctx = txt[:90]
                elif not last_ctx:
                    last_ctx = txt[:90]
            for rid in embeds_in(p):
                media = rmap.get(rid, "?")
                # prefer the containing paragraph's own text if it has any, else last_ctx
                ctx = (txt[:90] if txt else last_ctx)
                rows.append((cur_inv, ctx, rid, media))

        # write manifest
        manifest = os.path.join(args.out_dir, "manifest.tsv")
        with open(manifest, "w", encoding="utf-8") as f:
            f.write("idx\tinvestigation\tcontext\trId\tmedia\n")
            for i, (inv, ctx, rid, media) in enumerate(rows):
                f.write(f"{i}\t{inv}\t{ctx}\t{rid}\t{media}\n")
        print(f"{len(rows)} embedded images; manifest -> {manifest}")

        # extract matching media
        want = [r for r in rows if (args.filter is None or args.filter.lower() in r[0].lower())]
        seen = set()
        for inv, ctx, rid, media in want:
            if media in seen or media == "?":
                continue
            seen.add(media)
            data = z.read(media)
            out = os.path.join(args.out_dir, os.path.basename(media))
            with open(out, "wb") as f:
                f.write(data)
        print(f"extracted {len(seen)} media file(s) matching filter={args.filter!r} into {args.out_dir}")
        if args.filter:
            print("\n--- matching images (in reading order) ---")
            for inv, ctx, rid, media in want:
                print(f"  {os.path.basename(media):20} | {inv[:38]:38} | {ctx}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
