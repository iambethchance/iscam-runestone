#!/usr/bin/env python
"""pdf_pages.py — render a page range of a PDF to PNGs for visual reading.

The gold source for content is now a PDF (source/iscam4_RJMPWin26.pdf). Claude's
Read tool needs poppler to rasterize PDFs (not available here), so this renders
pages to PNGs with PyMuPDF (self-contained, no external poppler) which can then
be Read/viewed directly — including equations, images, and table layouts that
plain text extraction loses.

Usage (from repo root; write PNGs to the scratchpad, not the repo):
    # find the page numbers first, e.g.:
    uv run --with pypdf python -c "import pypdf; r=pypdf.PdfReader('source/iscam4_RJMPWin26.pdf'); \
        [print(i+1) for i,p in enumerate(r.pages) if 'Investigation 5.7:' in (p.extract_text() or '')]"
    # then render that range:
    uv run --with pymupdf python scripts/pdf_pages.py source/iscam4_RJMPWin26.pdf 352-359 "$SCRATCH/inv57"

Produces $SCRATCH/inv57-p352.png, -p353.png, ... Then Read each PNG.
"""
import sys


def parse_range(spec: str) -> range:
    if "-" in spec:
        a, b = spec.split("-", 1)
        return range(int(a), int(b) + 1)
    n = int(spec)
    return range(n, n + 1)


def main() -> int:
    if len(sys.argv) not in (4, 5):
        print("usage: pdf_pages.py <pdf> <start-end|page> <out-prefix> [dpi]", file=sys.stderr)
        return 2
    pdf_path, spec, prefix = sys.argv[1], sys.argv[2], sys.argv[3]
    dpi = int(sys.argv[4]) if len(sys.argv) == 5 else 150

    import fitz  # PyMuPDF

    doc = fitz.open(pdf_path)
    zoom = dpi / 72.0
    mat = fitz.Matrix(zoom, zoom)
    for pno in parse_range(spec):  # 1-indexed page numbers
        if pno < 1 or pno > doc.page_count:
            print(f"skip page {pno} (out of range 1..{doc.page_count})")
            continue
        page = doc.load_page(pno - 1)
        out = f"{prefix}-p{pno}.png"
        page.get_pixmap(matrix=mat).save(out)
        print(f"wrote {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
