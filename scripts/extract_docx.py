#!/usr/bin/env python
"""extract_docx.py — dump the paragraph text of a Word .docx/.docm for diffing.

The gold source for book content is a Word file (source/iscam4_RJMPFall25.docm). To
verify a .ptx matches it verbatim (see CLAUDE.md "Content Fidelity Mandate"), extract
the doc's text and grep for the investigation you're working on.

Usage (from repo root; write output to the scratchpad, not the repo):
    unzip -o -q source/iscam4_RJMPFall25.docm word/document.xml -d "$SCRATCH/docm"
    uv run --with lxml python scripts/extract_docx.py "$SCRATCH/docm/word/document.xml" "$SCRATCH/fulltext.txt"
    grep -n "Investigation 5.6" "$SCRATCH/fulltext.txt"     # then read that line range

One line per Word paragraph (<w:p>), tabs and soft line breaks preserved, so question
order and the blank answer-lines that mark the *student* version stay visible.
"""
import sys
import xml.etree.ElementTree as ET

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def para_text(p) -> str:
    parts = []
    for node in p.iter():
        if node.tag == W + "t":
            parts.append(node.text or "")
        elif node.tag == W + "tab":
            parts.append("\t")
        elif node.tag == W + "br":
            parts.append("\n")
    return "".join(parts)


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: extract_docx.py <document.xml> <out.txt>", file=sys.stderr)
        return 2
    root = ET.parse(sys.argv[1]).getroot()
    body = root.find(W + "body")
    lines = [para_text(p) for p in body.iter(W + "p")]
    with open(sys.argv[2], "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"wrote {len(lines)} paragraphs to {sys.argv[2]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
