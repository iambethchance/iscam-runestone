---
name: view-build
description: Visually inspect the rendered local PreTeXt build (MathJax formulas, images, tables, layout) by screenshotting a built page to PNG and viewing it. Use when you need to confirm how a page actually renders — e.g. a formula/equation displays correctly, an image shows, a table lays out right — which the raw HTML text cannot reveal. Requires a one-time Playwright install.
---

# view-build

Raw generated HTML (and the `.ptx` source) tells you the *content* but not how it *renders* —
you can't tell from text whether a `<m>`/`<me>` formula typesets correctly, whether an
`<image>` actually loads, or how a `<tabular>` lays out. This skill closes that gap: it renders a
built page in a real (headless) browser, screenshots it to PNG, and you view the PNG.

This is the "did my output render correctly?" check. It is **complementary** to comparing against
the gold Word source (which tells you what the content *should* be — ideally via a PDF export you
can Read directly). Use both when doing fidelity work: PDF for the source side, this for the
build side.

## One-time setup (optional QA tooling — intentionally NOT in requirements.txt)

Installing Playwright pulls a ~150 MB Chromium; don't force it on every dev or into the Runestone
build. Install it only on a machine doing visual QA:

```bash
uv pip install playwright
uv run playwright install chromium
```

## Workflow

1. Build the target you want to inspect (the served files must exist):
   ```bash
   pretext build runestone      # or: pretext build html
   ```
2. Screenshot a page with the helper (writes PNGs to the scratchpad, never the repo):
   ```bash
   # whole page:
   uv run python scripts/screenshot_build.py inv-5-7.html "$SCRATCH/inv57.png" --target runestone
   # just one element by CSS selector (faster to read, focused):
   uv run python scripts/screenshot_build.py inv-5-7.html "$SCRATCH/def.png" --selector ".definition-like"
   ```
   The script serves `output/<target>/` over a local HTTP server (so relative CSS/JS and MathJax
   resolve like a real browser), waits for MathJax to finish typesetting, then captures the PNG.
3. **Read the PNG** with the Read tool — it renders images visually, so you actually see the page.

## What to expect / caveats

- **It's the local build, not Runestone's server render.** Close enough for content/formula/image
  verification, but not byte-identical to what deploys (see CLAUDE.md on version drift). The
  authoritative post-deploy check is still Runestone's "view latest log" + the live page.
- **MathJax** is waited for automatically; if a formula still looks like raw `\(...\)`, bump the
  wait in the script or re-run.
- **External iframes/interactives** (Sage cells from sagecell.sagemath.org, rossmanchance.com
  applets) load over the network and may appear blank/loading in the shot — usually irrelevant for
  checking static content/formulas/tables.
- **Full-page screenshots of long investigations are tall** — use `--selector` to grab just the
  region you care about (e.g. a definition box or a table) for a quicker, sharper read.
- Build output can exit non-zero on unrelated pre-existing errors (e.g. dangling xrefs elsewhere)
  while still producing the page you want — the screenshot step only needs the page's HTML file to
  exist, so check for `output/<target>/<page>.html` rather than a clean build exit.
