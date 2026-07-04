#!/usr/bin/env python
"""screenshot_build.py — render a built PreTeXt page to PNG so it can be viewed.

Lets a (headless) reviewer visually check what the local build actually looks
like — MathJax formulas rendered, images loaded, tables laid out — which the raw
HTML text can't show. The PNG can then be opened/inspected directly.

Serves output/<target>/ over a local HTTP server (so relative CSS/JS and MathJax
resolve exactly as in a browser), loads one page, waits for MathJax to finish,
and screenshots either the whole page or a single element by CSS selector.

Prereqs (one-time; NOT in requirements.txt — this is an optional QA tool):
    uv pip install playwright
    uv run playwright install chromium

Build first, then screenshot. Examples (from repo root):
    pretext build runestone
    # whole page:
    uv run python scripts/screenshot_build.py inv-5-7.html "$SCRATCH/inv57.png"
    # just one element (e.g. the correlation-definition assemblage):
    uv run python scripts/screenshot_build.py inv-5-7.html "$SCRATCH/inv57-def.png" --selector ".assemblage-like"
    # a different target dir:
    uv run python scripts/screenshot_build.py inv-5-7.html "$SCRATCH/x.png" --target html

Then Read the PNG to view it. Write PNGs to the scratchpad, not the repo.
"""
import argparse
import functools
import http.server
import os
import socketserver
import threading

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def serve(directory: str) -> tuple[socketserver.TCPServer, int]:
    handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=directory)
    httpd = socketserver.TCPServer(("127.0.0.1", 0), handler)  # port 0 = pick a free port
    port = httpd.server_address[1]
    threading.Thread(target=httpd.serve_forever, daemon=True).start()
    return httpd, port


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("page", help="HTML filename within the target output dir, e.g. inv-5-7.html")
    ap.add_argument("out", help="output PNG path (write to the scratchpad, not the repo)")
    ap.add_argument("--target", default="runestone", help="output/<target> dir (default: runestone)")
    ap.add_argument("--selector", default=None, help="optional CSS selector to screenshot one element")
    ap.add_argument("--width", type=int, default=1100)
    args = ap.parse_args()

    outdir = os.path.join(REPO, "output", args.target)
    if not os.path.isfile(os.path.join(outdir, args.page)):
        print(f"ERROR: {args.page} not found in output/{args.target}/ — run `pretext build {args.target}` first.")
        return 2

    from playwright.sync_api import sync_playwright

    httpd, port = serve(outdir)
    url = f"http://127.0.0.1:{port}/{args.page}"
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch()
            page = browser.new_page(viewport={"width": args.width, "height": 1400})
            page.goto(url, wait_until="networkidle")
            # Wait for MathJax (if present) to finish typesetting so formulas render.
            page.wait_for_timeout(500)
            try:
                page.wait_for_function(
                    "() => !window.MathJax || !MathJax.startup || "
                    "MathJax.startup.document.state() >= 10",
                    timeout=8000,
                )
            except Exception:
                pass  # no MathJax / already done
            page.wait_for_timeout(500)
            if args.selector:
                el = page.query_selector(args.selector)
                if el is None:
                    print(f"WARN: selector {args.selector!r} not found; capturing full page instead.")
                    page.screenshot(path=args.out, full_page=True)
                else:
                    el.screenshot(path=args.out)
            else:
                page.screenshot(path=args.out, full_page=True)
            browser.close()
    finally:
        httpd.shutdown()

    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
