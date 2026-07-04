#!/usr/bin/env python
"""ptx_lint.py — repo-specific PreTeXt linter for the ISCAM Runestone book.

Catches the classes of problem that have actually bitten this project (and that a
plain `pretext build` either tolerates non-fatally or reports too late), so they can
be caught BEFORE committing/pushing to Runestone:

  ERROR-level (should fix before pushing):
    * dotted @label values           -> rejected by pretext >= ~2.40 / Runestone server
    * dangling <xref ref="...">       -> the fatal "does not point to any target" build error
    * duplicate xml:id                -> ambiguous xref targets
    * xi:include of a missing file
    * <image source> file missing
    * <image source> case mismatch    -> works on Windows/Mac, BREAKS on Runestone's Linux
    * <p> directly wrapping a block list (<ul>/<ol>) -> deprecated block-in-inline

  WARN-level (worth a look, not necessarily wrong):
    * .ptx files under source/ not reachable from main.ptx (orphans/backups)
    * parentheses in an <image source> filename (repo convention forbids them)

This is intentionally regex/heuristic based (fast, line-numbered) rather than a full
schema validator. For strict schema validation use `pretext validate` (needs jing +
Java; see scripts/setup-jing.ps1). Run this from the repo root:

    python scripts/ptx_lint.py            # or: uv run python scripts/ptx_lint.py

Exit code is 1 if any ERROR-level findings, else 0.
"""
from __future__ import annotations
import os
import re
import sys
from collections import defaultdict

# Windows consoles default to cp1252 and mangle Unicode in findings; force UTF-8.
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE = os.path.join(REPO, "source")
ASSETS = os.path.join(REPO, "assets")
MAIN = os.path.join(SOURCE, "main.ptx")

# --- lightweight regexes (attribute extraction; good enough for a linter) ---
RE_INCLUDE = re.compile(r'<xi:include\s+href="([^"]+)"')
RE_XMLID = re.compile(r'\bxml:id="([^"]+)"')
RE_LABEL = re.compile(r'\blabel="([^"]+)"')
RE_XREF = re.compile(r'<xref\b[^>]*\bref="([^"]+)"')
RE_IMAGE = re.compile(r'<image\b[^>]*\bsource="([^"]+)"')
RE_P_BLOCKLIST = re.compile(r'<p>\s*<(ul|ol)\b|</(ul|ol)>\s*</p>')

errors: list[str] = []
warns: list[str] = []


def rel(path: str) -> str:
    return os.path.relpath(path, REPO).replace("\\", "/")


def lines_of(path: str) -> list[str]:
    with open(path, encoding="utf-8") as f:
        return f.readlines()


def resolve_includes(start: str) -> list[str]:
    """Return the ordered list of files reachable from `start` via xi:include."""
    seen: list[str] = []
    stack = [start]
    while stack:
        cur = stack.pop(0)
        if cur in seen:
            continue
        seen.append(cur)
        try:
            text = open(cur, encoding="utf-8").read()
        except OSError:
            continue
        base = os.path.dirname(cur)
        # preserve document order for the newly discovered includes
        found = [os.path.normpath(os.path.join(base, h)) for h in RE_INCLUDE.findall(text)]
        for i, f in enumerate(found):
            if not os.path.exists(f):
                errors.append(f"[missing-include] {rel(cur)} includes {rel(f)} which does not exist")
        stack = found + stack
    return seen


def main() -> int:
    if not os.path.exists(MAIN):
        print(f"FATAL: {rel(MAIN)} not found — run from repo root.", file=sys.stderr)
        return 2

    included = resolve_includes(MAIN)
    included_set = set(included)

    ids: dict[str, list[str]] = defaultdict(list)   # id -> [locations]
    labels: dict[str, list[str]] = defaultdict(list)
    xrefs: list[tuple[str, str]] = []               # (ref, location)

    for path in included:
        for lineno, line in enumerate(lines_of(path), 1):
            loc = f"{rel(path)}:{lineno}"
            for m in RE_XMLID.finditer(line):
                ids[m.group(1)].append(loc)
            for m in RE_LABEL.finditer(line):
                val = m.group(1)
                labels[val].append(loc)
                if "." in val:
                    errors.append(f"[dotted-label] {loc}  label=\"{val}\" — periods are rejected by "
                                  f"pretext>=~2.40 (use hyphens/underscores)")
            for m in RE_XREF.finditer(line):
                xrefs.append((m.group(1), loc))
            for m in RE_IMAGE.finditer(line):
                check_image(m.group(1), loc)
            if RE_P_BLOCKLIST.search(line):
                errors.append(f"[p-wraps-list] {loc}  a <p> directly wraps a <ul>/<ol> block "
                              f"(deprecated; the list should not be inside <p>)")

    # duplicate ids
    for _id, locs in sorted(ids.items()):
        if len(locs) > 1:
            errors.append(f"[dup-xml:id] xml:id=\"{_id}\" defined {len(locs)}x: {', '.join(locs)}")

    # dangling xrefs (a ref may target an xml:id OR a label)
    valid_targets = set(ids) | set(labels)
    for ref, loc in xrefs:
        if ref not in valid_targets:
            errors.append(f"[dangling-xref] {loc}  <xref ref=\"{ref}\"> has no matching xml:id/label")

    # orphan .ptx files (present under source/ but not reachable from main.ptx)
    for dirpath, _dirs, files in os.walk(SOURCE):
        for fn in files:
            if fn.endswith(".ptx"):
                full = os.path.normpath(os.path.join(dirpath, fn))
                if full not in included_set:
                    warns.append(f"[orphan-file] {rel(full)} is not xi:included from main.ptx "
                                 f"(backup/dev/unfinished?)")

    report()
    return 1 if errors else 0


def check_image(source: str, loc: str) -> None:
    if "(" in source or ")" in source:
        warns.append(f"[image-parens] {loc}  <image source=\"{source}\"> contains parentheses "
                     f"(repo convention forbids them in image filenames)")
    # resolve against assets/ with exact-case checking, segment by segment
    parts = source.split("/")
    cur = ASSETS
    for seg in parts:
        if not os.path.isdir(cur):
            errors.append(f"[image-missing] {loc}  <image source=\"{source}\"> not found under assets/")
            return
        entries = os.listdir(cur)
        if seg in entries:
            cur = os.path.join(cur, seg)
        else:
            lower = {e.lower(): e for e in entries}
            if seg.lower() in lower:
                errors.append(f"[image-case] {loc}  <image source=\"{source}\"> — case mismatch: "
                              f"source has \"{seg}\" but file on disk is \"{lower[seg.lower()]}\" "
                              f"(works on Windows, BREAKS on Runestone Linux)")
                cur = os.path.join(cur, lower[seg.lower()])
            else:
                errors.append(f"[image-missing] {loc}  <image source=\"{source}\"> not found under assets/")
                return


def report() -> None:
    if errors:
        print(f"\n=== {len(errors)} ERROR-level finding(s) ===")
        for e in errors:
            print("  ERROR " + e)
    if warns:
        print(f"\n=== {len(warns)} WARN-level finding(s) ===")
        for w in warns:
            print("  WARN  " + w)
    if not errors and not warns:
        print("ptx_lint: clean — no findings.")
    else:
        print(f"\nptx_lint summary: {len(errors)} error(s), {len(warns)} warning(s).")


if __name__ == "__main__":
    raise SystemExit(main())
