# CLAUDE.md — ISCAM Runestone Project

## Project Overview

This is a conversion of **ISCAM: Investigating Statistical Concepts, Applications, and Methods** (Beth Chance & Allan Rossman) — an introductory statistics textbook using active learning — to the [PreTeXt](https://pretextbook.org/) format for deployment on [Runestone Academy](https://runestone.academy). Canonical source content (data files, original HTML pages, applets) lives at rossmanchance.com; this repo is the conversion target.

The book uses an investigation-based, inquiry-first pedagogy: content is organized as numbered **Investigations** within chapters, each walking through a real study with a sequence of guided exercises, ending in "Study Conclusions" and one or more "Practice Problem" subsections.

GitHub remote: `iambethchance/iscam-runestone`, branch `master`. Runestone Academy builds directly from this branch — there is no separate deploy step for normal edits (see Deployment below).

### Platform background

Runestone's native authoring path is reStructuredText with directives (e.g. `.. activecode::`) that compile down to HTML/JS "Runestone Components" (activecode, multiple choice, etc.) served by the Runestone Server. This project bypasses RST entirely and authors in PreTeXt, which compiles to the same underlying components — so PreTeXt's `<exercise>`/`<sage>`/`<interactive>` elements are the source of truth here, never RST syntax. Runestone publishes a "Runestone Components/Directives" reference documenting what components exist and how they behave (linked from the author guide) — worth consulting if a PreTeXt element doesn't seem to have an obvious Runestone-rendered equivalent, but get the current URL from the user/runestone.academy nav rather than assuming one, since it isn't confirmed here.

Separately, Runestone distinguishes **open books** (no login, self-paced) from **custom courses** (instructor-created, gradebook/assignments/progress tracking, built from a copy of the book at a point in time). `<public>no</public>` in `publication/runestone.ptx` controls whether this book is listed for other instructors to build a custom course from — it doesn't affect whether the book itself builds or is viewable.

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

`requirements.txt` pins `pretext==2.33.2`. `pretext build` may print a notice that a newer version is available — that's expected; don't upgrade without checking that the newer CLI doesn't change output structure Runestone depends on.

## Build Commands

```bash
# Build for Runestone target
pretext build runestone

# Preview locally (opens at http://localhost:8128)
pretext view runestone

# Build for plain HTML target
pretext build html
```

Builds routinely emit warnings (deprecation notices, some chapter 5 xref warnings) that have been treated as non-fatal/out-of-scope historically. Don't assume a clean build is required before committing — but do check that the specific file you touched didn't introduce a *new* warning or error.

## Repository Layout

`source/main.ptx` is the single source of truth for which files are actually part of the book — it `xi:include`s each chapter/section file in reading order. **Don't infer book structure from filenames alone**: this repo has accumulated many superseded/experimental files that are *not* included anywhere (e.g. `main-backup.ptx`, `main-article-backup.ptx`, `main-book.ptx`, `main-ch5-dev.ptx`, `ch-1-monolithic-backup.ptx`, `ch-1-modular.ptx`, `inv-1-2-backup.ptx`, `inv-1-2-old.ptx`). When looking for "the" version of something, grep `main.ptx`'s include list first, then find the matching file.

```
project.ptx                  # Build targets (html, runestone); also pins the active CSS version (see below)
publication/
  publication.ptx            # Plain-html target settings
  runestone.ptx               # Runestone publication settings (book-id, SageCell server, exercise visibility)
source/
  main.ptx                    # Book structure — xi:includes everything below, in order
  frontmatter.ptx / backmatter.ptx
  ch-0-prelim.ptx              # Preliminaries (Inv A, B, C)
  ch-N-intro.ptx, ch-sec-N-M.ptx, ch-N.ptx, ch-N-M.ptx  # chapter/section files (naming is inconsistent across chapters — check main.ptx)
  chN/                         # per-chapter investigation files, e.g. source/ch1/inv-1-1.ptx, source/ch5/inv-5-4.ptx
    section-wrap-up.ptx        # end-of-chapter wrap-up, included from main.ptx
assets/
  images/, tech_images/        # investigation images vs. technology-output screenshots (see Images below)
  iscam-vNN.css                 # cache-busted stylesheet history — only the version referenced in project.ptx is live (see CSS Cache-Busting)
data/                          # local mirror of raw datasets (.txt), also hosted at rossmanchance.com
.claude/skills/                # project skills (tracked in git — see Skills below)
```

**Do not commit:** `output/`, `generated-assets/`, `logs/` (build artifacts, already gitignored).

**Repo hygiene note:** the root directory has accumulated a lot of one-off debug scripts (`fix_bullets.py`, `clean_html_v2.py`, `add_h2_headings.py`, …), temp logs (`build-log.txt`, `bullet_audit*.txt`, `_git_log_now.txt`), and session handoff notes (`SESSION-HANDOFF-*.md`) that are already committed. Don't add more of these to the repo root — if you need a scratch file for a one-off script or log during a session, use the scratchpad temp directory instead of the project root. Treat existing root-level `.md`/`.txt`/script cruft as historical residue, not documentation to maintain, unless a file is explicitly linked from this CLAUDE.md.

## Authoring Conventions

### PreTeXt XML structure for an Investigation

Use `source/ch1/inv-1-1.ptx` as the reference template. The consistent shape:

```xml
<section xml:id="invN-M">
  <title>Investigation N.M: <!-- title --></title>
  <introduction><p><em><!-- framing paragraph --></em></p></introduction>

  <exercises xml:id="investigationN-M" hidden-label="yes">
    <title hidden-label="yes">The Study</title>
    <introduction><!-- study background, may include <aside> for videos, <sidebyside>+<image> --></introduction>

    <paragraphs>
      <title><!-- e.g. "Collecting the Data" --></title>
      <assemblage xml:id="def-...">  <!-- reusable definition callouts -->
        <title>Definition: ...</title>
        <p><term>...</term> ...</p>
      </assemblage>
      <exercise xml:id="invN-M-a" label="IN.M.1">
        <title><!-- short imperative title, e.g. "Identify the Sample" --></title>
        <statement>
          <p>...</p>
          <hint><p>...</p></hint>
        </statement>
        <response/>
        <solution><p>...</p></solution>
      </exercise>
      <!-- more exercises: invN-M-b, invN-M-c, ... label IN.M.2, IN.M.3, ... -->
    </paragraphs>
    <!-- more <paragraphs> blocks, typically: Summarizing the Observed Data, Drawing Conclusions
         Beyond the Sample, Simulation, Discussion -->

    <assemblage xml:id="study-conclusions-N-M">
      <title>Study Conclusions</title>
      <p><!-- wrap-up paragraph --></p>
    </assemblage>
  </exercises>

  <subsection xml:id="practiceN-MA">
    <title>Practice Problem N.MA</title>
    <!-- exercises labeled PPN.MA.1, PPN.MA.2, ... -->
  </subsection>
  <!-- optionally practiceN-MB, ... -->
</section>
```

Key conventions:
- `xml:id` values are kebab-case and unique book-wide (e.g. `inv1-1`, `inv1-1-a`, `practice1-1A`, `def-sample`).
- `label` values follow `I<chapter>.<investigation>.<n>` for main exercises and `PP<chapter>.<investigation><letter>.<n>` for practice problems.
- Open-ended/discussion questions get `<response/>` (a free-text box) and usually a `<solution>`; multiple-choice questions use `<choices randomize="yes" multiple-correct="no">` with `<choice correct="yes"|"no"><statement>...</statement><feedback>...</feedback></choice>` for every option — always write feedback for both correct and incorrect choices, don't leave any choice's feedback empty.
- `<assemblage>` is used for both reusable definition callouts and the closing "Study Conclusions" box — not for individual exercises.
- Use current PreTeXt `<exercise>`/`<choices>` formatting, never legacy Runestone RST/HTML.
- Use `xi:include` to keep chapters modular; never inline large investigation content directly into `main.ptx`.
- Match wording to the original Word/HTML source when converting existing content (see `MarkdownTranslation.md`) rather than paraphrasing — several past commits exist solely to fix wording drift from the source.

### Interactive R Code
- Use `<sage language="r">` with `<input>` blocks for executable R cells.
- **Each Sage cell is fully independent** — variables do not persist between cells. Use a cumulative code pattern: repeat all setup code in every cell that needs it (comment repeated setup as "from earlier" so students see what's new).
- Always use explicit `print()` for all output (e.g. `print(table(data))`, not just `table(data)`) — otherwise students may see a raw `<rpy2.rinterface_lib.sexp.NULLType ...>` object instead of output.
- Use `&lt;-` (XML-encoded) for R's assignment operator `<-` inside `.ptx` source files.
- **Open question, verify before relying on either behavior:** `RUNESTONE-DEPLOYMENT.md` states Sage cells cannot load external URLs and datasets must be inlined with `data.frame()`. However, `source/ch1/inv-1-1.ptx` has a live cell doing `read.table("https://raw.githubusercontent.com/iambethchance/iscam-runestone/master/data/InfantData.txt", ...)`. Don't assume either the doc or the existing cell is correct — actually run the cell in a built/previewed page before copying the pattern for new content.

### Applets / Iframes
- Interactive applets (mostly rossmanchance.com apps) are embedded as `<interactive iframe="..." aspect="W:H"/>`, e.g. `aspect="3:2"`. Widths are sometimes intentionally >100% (e.g. `width="160%"`) to make cramped applets usable — check rendered output rather than assuming 100% is always right.
- The publication sets `resize-behavior="responsive"` and `design-width="900"` for proper display.

### Images
- `assets/images/` holds investigation-specific images (screenshots, diagrams); `assets/tech_images/` holds technology-output screenshots (R/JMP/Minitab console output) referenced from "tech detour" hints. Follow this split for new images rather than dumping everything in one folder.
- Filenames must not contain parentheses.
- Reference images with `<image source="images/filename.ext">` or `<image source="tech_images/filename.ext">` and always include a `<description>` for accessibility.

### CSS Cache-Busting
Runestone/browsers can aggressively cache the stylesheet, so content-only CSS edits can silently fail to appear. The proven workaround (see `assets/iscam-v*.css` history):
1. Copy the current live CSS file (referenced by `html.css.extra` in `project.ptx`) to a new `iscam-vNN.css` with the version bumped.
2. Make your CSS edits in the new file.
3. Update the `html.css.extra` stringparam in `project.ptx` to point at the new filename.
4. Rebuild, verify the generated HTML references the new filename, commit, and push.

Don't edit an old `iscam-vNN.css` in place expecting it to take effect — always bump the version. Old version files are left in `assets/` as history; don't delete them without checking nothing still references them.

## Deployment

- Runestone book ID: `iscam` (`publication/runestone.ptx`). `<public>no</public>` is currently set — the book is not yet publicly listed for course creation on Runestone.
- Runestone Academy builds directly from GitHub (`master` branch) — pushing to `master` is effectively deploying.

Workflow:
1. Edit source `.ptx` files.
2. Build and preview locally with `pretext build runestone` / `pretext view runestone`.
3. Commit and push to GitHub — Runestone pulls and rebuilds automatically. Small, scoped commits pushed incrementally have worked better than large batched ones for isolating build issues.

## Skills

Project-specific Claude Code skills live in `.claude/skills/` and are tracked in git (unlike the rest of `.claude/`, which stays local via `.gitignore`). Current skills:

- `new-investigation` — scaffold a new Investigation `.ptx` file following the structure above.

## Key Reference Docs in This Repo

- [RUNESTONE-DEPLOYMENT.md](RUNESTONE-DEPLOYMENT.md) — Deployment guide and Sage cell usage notes (see caveat above about the external-URL claim).
- [CONVERSION-SUMMARY.md](CONVERSION-SUMMARY.md) — History of the book structure conversion (as of Nov 2025; structure has since evolved further — treat as historical context, not current state).
- [MarkdownTranslation.md](MarkdownTranslation.md) — Conversion best practices (currently just: use current PreTeXt exercise formatting, not legacy Runestone formatting).
