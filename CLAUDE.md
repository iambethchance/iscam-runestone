# CLAUDE.md — ISCAM Runestone Project

## Project Overview

This is a conversion of **ISCAM: Investigating Statistical Concepts, Applications, and Methods** — an introductory statistics textbook using active learning — to the [PreTeXt](https://pretextbook.org/) format for deployment on [Runestone Academy](https://runestone.academy).

The book uses an investigation-based, inquiry-first pedagogy aimed at mathematically inclined students. Content is organized as numbered investigations within chapters.

## Dev Environment Setup (first time on a new machine)

**1. Install uv** — run this in PowerShell (not Git Bash):
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**2. Create a virtual environment and install pretext** — in Git Bash from the project root:
```bash
uv venv
source .venv/Scripts/activate
uv pip install -r requirements.txt
```

**3. Activate the venv on subsequent sessions:**
```bash
source .venv/Scripts/activate
```

## Build Commands

```bash
# Build for Runestone target
pretext build runestone

# Preview locally (opens at http://localhost:8128)
pretext view runestone

# Build for plain HTML target
pretext build html
```

## File Structure

```
project.ptx                  # Build targets (html, runestone)
publication/
  runestone.ptx              # Runestone publication settings (design-width=900, SageCell, etc.)
source/
  main.ptx                   # Top-level book file (xi:includes all chapters)
  frontmatter.ptx            # Preface
  backmatter.ptx             # Appendices, index, colophon
  ch-0-prelim.ptx            # Preliminaries chapter (Inv A, B, C)
  ch-1-intro.ptx             # Chapter 1 intro
  ch-1.ptx / ch-2.ptx / ch-3.ptx  # Chapter sections (proportions)
  ch-2-intro.ptx / ch-sec-2-1.ptx / ch-5.ptx / ch-6.ptx  # Chapter 2 (quantitative)
  ch-3-intro.ptx / ch-3-1.ptx … ch-3-4.ptx  # Chapter 3 (comparing proportions)
  ch-4-intro.ptx / ch-sec-4-1.ptx … ch-sec-4-4.ptx  # Chapter 4 (quantitative comparisons)
  ch1/ ch2/ ch3/ ch4/        # Section wrap-up files per chapter
assets/                      # Images and static files
```

**Do not commit:** `output/`, `generated-assets/`, `logs/` (these are build artifacts).

## Authoring Conventions

### PreTeXt XML
- Always use PreTeXt element syntax, not raw Runestone RST/HTML.
- For exercises, use current PreTeXt `<exercise>` formatting (not legacy Runestone format).
- Attribute `xml:id` values should be kebab-case and unique across the book (e.g., `inv-1-1-friend-or-foe`).
- Use `xi:include` to keep chapters modular; never inline large content into `main.ptx`.

### Interactive R Code
- Use `<sage language="r">` with `<input>` blocks for executable R cells.
- **Each Sage cell is fully independent** — variables do not persist between cells.
- Use a cumulative code pattern: repeat all setup code in each cell that needs it.
- Always use explicit `print()` for all output (e.g., `print(table(data))`, not just `table(data)`).
- Use `&lt;-` (XML-encoded) for R's assignment operator `<-` inside `.ptx` source files.
- Sage cells **cannot** load external URLs; embed small datasets inline with `data.frame()`.

### Applets / Iframes
- Interactive applets are embedded as `<interactive>` elements with iframes.
- The publication sets `resize-behavior="responsive"` and `design-width="900"` for proper display.

### Images
- Image files live in `assets/`. Filenames must not contain parentheses.
- Reference images with `<image source="filename"/>` (no path prefix needed when `assets/` is configured).

## Deployment

The Runestone book ID is `iscam` (set in `publication/runestone.ptx`).
Runestone Academy builds directly from the GitHub repository (`master` branch).

Workflow:
1. Edit source `.ptx` files.
2. Build and preview locally with `pretext build runestone` / `pretext view runestone`.
3. Commit and push to GitHub — Runestone pulls and rebuilds automatically.

## Key Reference Docs in This Repo

- [RUNESTONE-DEPLOYMENT.md](RUNESTONE-DEPLOYMENT.md) — Detailed deployment guide and Sage cell usage notes.
- [CONVERSION-SUMMARY.md](CONVERSION-SUMMARY.md) — History of the book structure conversion.
- [MarkdownTranslation.md](MarkdownTranslation.md) — Conversion best practices.
