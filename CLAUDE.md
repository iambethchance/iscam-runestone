# CLAUDE.md — ISCAM Runestone Project

## Project Overview

This is a conversion of **ISCAM: Investigating Statistical Concepts, Applications, and Methods** (Beth Chance & Allan Rossman) — an introductory statistics textbook using active learning — to the [PreTeXt](https://pretextbook.org/) format for deployment on [Runestone Academy](https://runestone.academy). Canonical source content (data files, original HTML pages, applets) lives at rossmanchance.com; this repo is the conversion target.

The book uses an investigation-based, inquiry-first pedagogy: content is organized as numbered **Investigations** within chapters, each walking through a real study with a sequence of guided exercises, ending in "Study Conclusions" and one or more "Practice Problem" subsections.

## ⚠️ Content Fidelity Mandate — READ THIS FIRST

**This project is a _format conversion_, not an editorial rewrite. The job is to move the exact
content of the source textbook into PreTeXt — nothing more.**

The authoritative source of truth for content is the Word document
[`source/iscam4_RJMPFall25.docm`](source/iscam4_RJMPFall25.docm) (the current gold master; if a
newer dated `.docm` appears in `source/`, confirm with the author which is canonical). Every
question, discussion paragraph, definition, technology instruction, study conclusion, and
practice problem in a `.ptx` file must match the wording in that Word document **verbatim**.

You may ONLY change what is required to express the content in PreTeXt XML, specifically:
- Wrapping text in the correct PreTeXt elements (`<p>`, `<exercise>`, `<statement>`, `<term>`,
  `<q>`, `<alert>`, `<tabular>`, etc.).
- XML-encoding characters (`&lt;`, `&amp;`), converting straight/curly quotes to `<q>…</q>`,
  em dashes to `<mdash/>`, etc.
- Adding structural attributes the format needs (`xml:id`, `label`).
- Placing images/applets/data where the Word doc shows them.

You may **NOT**, unless the author explicitly asks in this session:
- Reword, paraphrase, condense, "tighten," or "improve" any question or discussion text.
- Invent solutions/answers from your own statistical knowledge. **The `RJMPFall25` doc is the
  _student_ version — most questions have blank answer spaces.** Solution text comes from a
  **separate author-supplied instructor key**, not from you. So: don't fabricate solutions, but
  also don't assume existing `<solution>` blocks are wrong just because they aren't in the
  student doc — they were likely sourced from the instructor key. **Leave `<solution>` content
  alone unless the author says otherwise.**
- Drop content that is in the doc (data tables, full multi-platform technology instructions,
  terminology detours, transition sentences between parts, etc.).
- Renumber or relabel questions in a way that departs from the doc's own lettering/numbering.

**Known hazard:** several existing `.ptx` files (e.g. `source/ch5/inv-5-6.ptx`) were generated
by an earlier LLM pass that silently paraphrased and compressed the **question / discussion /
detour / conclusion wording** (the `<solution>` blocks came from the instructor key and are
generally fine). When touching any converted file, diff the non-solution text against the Word
doc first (see the extraction workflow below) and restore verbatim wording before doing anything
else. Treat "the `.ptx` already says X" as suspect for question/body text until verified against
the doc; leave solutions as-is.

### Reading the gold source for comparison

There are two source artifacts, both under `source/` and both `.gitignore`d (never commit them):

- **`iscam4_RJMPWin26.pdf`** — Winter 2026 PDF. **Preferred gold source: read it visually.** It
  shows equations, scatterplot images, and table layouts that text extraction loses (this is how
  the Inv 5.7 correlation formula was verified). Rendered PNGs are legible and reliable.
- **`iscam4_RJMPFall25.docm`** — Fall 2025 Word doc. Older; useful as a text stream for grep/diff.
  **Note the version gap:** if the PDF and docm disagree, the PDF (Win26) is newer — prefer it.

**Read the PDF visually** (Claude's Read tool needs poppler, absent here, so rasterize with
PyMuPDF; run from repo root, write PNGs to the scratchpad, never the repo):
```bash
# 1. find the page number(s) for an investigation
uv run --with pypdf python -c "import pypdf; r=pypdf.PdfReader('source/iscam4_RJMPWin26.pdf'); \
  [print(i+1) for i,p in enumerate(r.pages) if 'Investigation 5.7:' in (p.extract_text() or '')]"
# 2. render that page range to PNGs, then Read each PNG
uv run --with pymupdf python scripts/pdf_pages.py source/iscam4_RJMPWin26.pdf 352-359 "$SCRATCH/inv57"
```
(The PDF's printed page number is one less than the file page index — file page 352 shows "351".)

**Text stream from the Word doc** (faster for prose grep/diff, but drops equations/images):
```bash
unzip -o -q source/iscam4_RJMPFall25.docm word/document.xml -d "$SCRATCH/docm"
uv run --with lxml python scripts/extract_docx.py "$SCRATCH/docm/word/document.xml" "$SCRATCH/fulltext.txt"
grep -n "Investigation 5.6" "$SCRATCH/fulltext.txt"   # then read that line slice
```

Helpers: [`scripts/pdf_pages.py`](scripts/pdf_pages.py) (PDF page → PNG),
[`scripts/extract_docx.py`](scripts/extract_docx.py) (Word paragraphs → text; preserves the blank
answer lines that mark the student version).
Write the extracted text to the scratchpad, never the repo.

GitHub remote: `iambethchance/iscam-runestone`, branch `master`. Runestone Academy builds directly from this branch — there is no separate deploy step for normal edits (see Deployment below).

### Platform background

Runestone's native authoring path is reStructuredText with directives (e.g. `.. activecode::`) that compile down to HTML/JS "Runestone Components" (activecode, multiple choice, etc.) served by the Runestone Server. This project bypasses RST entirely and authors in PreTeXt, which compiles to the same underlying components — so PreTeXt's `<exercise>`/`<sage>`/`<interactive>` elements are the source of truth here, never RST syntax. Runestone publishes a "Runestone Components/Directives" reference documenting what components exist and how they behave (linked from the author guide) — worth consulting if a PreTeXt element doesn't seem to have an obvious Runestone-rendered equivalent, but get the current URL from the user/runestone.academy nav rather than assuming one, since it isn't confirmed here.

Separately, Runestone distinguishes **open books** (no login, self-paced) from **custom courses** (instructor-created, gradebook/assignments/progress tracking, built from a copy of the book at a point in time). `<public>no</public>` in `publication/runestone.ptx` controls whether this book is listed for other instructors to build a custom course from — it doesn't affect whether the book itself builds or is viewable.

## Dev Environment Setup (first time on a new machine)

**1. Install uv** — run this in PowerShell (not Git Bash):
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Always use `uv` for anything Python** (installs, running scripts): `uv pip install …`,
`uv run python …`. `uv` is already installed. Don't call bare `pip`/`python` for environment
changes.

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

**4. (Optional but recommended) enable `pretext validate`** — needs a Java-backed `jing`:
```bash
# install a JRE once (PowerShell): winget install EclipseAdoptium.Temurin.21.JRE
#   (the installer adds java to the machine PATH — open a FRESH terminal afterward)
powershell -ExecutionPolicy ByPass -File scripts/setup-jing.ps1   # creates the jing shim
```
`requirements.txt` already includes `jingtrang`; without the JRE + shim, `pretext validate` just
reports "no validator available" and skips (the build itself still works).

**5. (Optional) enable visual QA of the build with Playwright** — lets you (and Claude, via
screenshot → image) actually *see* how a built page renders (MathJax formulas, images, tables),
which raw HTML can't show. Install only on machines doing visual QA; it pulls a ~150 MB Chromium
and is **intentionally not in `requirements.txt`** (don't burden every dev / the Runestone build):
```bash
uv pip install playwright
uv run playwright install chromium
```
Then build a target and use `scripts/screenshot_build.py` — see the `view-build` skill for the
workflow. This is the recommended way to verify a page renders correctly before/after pushing.

### PreTeXt version — keep it matched to Runestone's server

`requirements.txt` pins **`pretext==2.43.1`**. This is deliberate: **Runestone Academy does not use
your `requirements.txt`** — its server (the `RunestoneInteractive/rs` codebase) builds with its
*own* pinned pretext (~2.43 as of mid-2026) via the PreTeXt Python API in-process. The local pin is
kept close to the server's to minimize "builds/looks fine locally, breaks or renders differently
after the Runestone rebuild" drift. (The project historically ran 2.33.2 and hit exactly this
class of surprise.) When bumping the local pin, prefer whatever the current Runestone server runs,
and re-run a full build + `scripts/ptx_lint.py` afterward, since newer pretext is stricter (e.g.
2.4x rejects dotted `@label` values that 2.33 tolerated).

There is **no supported way to reproduce the Runestone server build exactly** locally (its build
path isn't published as an author workflow). So the realistic safety net is: match the version,
lint, build, and **always read the "view latest log" link in Runestone's author interface after a
server rebuild** — that server log is the final source of truth for what deployed.

## Build Commands

```bash
# Build for Runestone target (what Runestone actually builds)
pretext build runestone

# Preview locally (opens at http://localhost:8128)
pretext view runestone

# Build for plain HTML target
pretext build html

# Repo-specific pre-push linter (fast; catches build-breakers + local-vs-Runestone traps)
uv run python scripts/ptx_lint.py

# Strict RELAX-NG schema validation (needs the jing shim + JRE; see setup step 4)
pretext validate
```

**Fatal vs. non-fatal is the key distinction.** `pretext build` prints many `* PTX:ERROR:` /
`* PTX:BUG:` lines that are **non-fatal** — the build still completes and deploys. Only a trailing
`critical:` … "Failed to build without errors" actually stops the build (in this repo, almost
always a dangling `<xref>`). Known-tolerated non-fatal noise: 900+ dotted-`@label` errors and
`hN template … aside` BUG lines, both book-wide. So: don't chase a "clean" build; instead confirm
(a) no `critical:` failure and (b) the file you touched didn't add a *new* error — grep the log for
your file's ids rather than reading all ~1900 lines. Run `scripts/ptx_lint.py` first; it isolates
the handful of findings that matter (see the `ptx-lint` skill for how to read each finding type).

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

### Runestone formatting conventions — the reference file is `source/ch5/inv-5-1.ptx`

**`source/ch5/inv-5-1.ptx` is the gold-standard, author-approved formatting template. Match it,
not the older ch1 files.** The author verified these against the Runestone-rendered output; follow
them for every investigation:

1. **No `(a)`/`(b)`/`(c)` prefixes in question text.** Runestone auto-numbers exercises (they render
   as "1.", "2.", …). Strip the letter prefixes from statements.
2. **Main exercises carry `xml:id` only — no `label` attribute.** Runestone numbers them; adding a
   `label` (especially a dotted one like `I5.7.a`) is both unnecessary and a lint/build error.
   *Practice-problem* exercises are the exception: they take a `label` like `P5.7A.1`.
3. **Study Conclusions must be `<assemblage xml:id="study-conclusions-N-M">`** (e.g.
   `study-conclusions-5-7`). That id is what the CSS targets to give the box its green styling; a
   plain `<assemblage>` renders in the wrong color.
4. **Cross-reference other questions with `<xref ref="inv5-7-a" text="custom">Question 1</xref>`.**
   The `text="custom">Question N` matches the visible auto-numbering; a bare `<xref ref="…"/>`
   renders the verbose internal number ("Exercise 26.2.1.1"). Never write "see part (a)" as plain
   text once the letters are gone.
5. **Practice problems go in `<subsection xml:id="practice-N-M">` OUTSIDE `</exercises>`** (a child
   of `<section>`), with shared setup in `<introduction>` and each part as its own `<exercise>`
   (auto-numbered). Split a multi-part practice problem into separate exercises.
6. **Technology instructions use the hint-reveal format:** inside a `<statement>`, one `<hint>` per
   platform — `<hint><title>Applet Instructions</title>…</hint>`, then `R Instructions`,
   `Minitab Instructions`, `JMP Instructions`. Either fold them into the relevant question or make a
   standalone `<paragraphs><title>Technology Detour</title><exercise>…</exercise></paragraphs>`.
7. **Study background / intro goes in `<introduction>` inside `<exercises>`.**
8. **`<image>` `<description>` must wrap its text in `<p>`** (`<description><p>…</p></description>`),
   not bare text — the current schema requires it.

### Pulling official solutions (verbatim)

`<solution>` blocks should be taken **verbatim from the official brief-solutions site**, not
paraphrased or invented. Some solutions include images (technology output) — pull those too.

- URL: `https://www.rossmanchance.com/iscam4/solutions/chapter<N>.html?part=all&software=all`
- It's HTTP Basic Auth; **credentials are in `.claude/solutions-access.md` (local, gitignored —
  never commit them; this repo is public).** Ask the author (bchance) if that file is missing.
- Fetch with Playwright `http_credentials` (rossmanchance.com is not Cloudflare-blocked, unlike
  runestone.academy). Then diff each `<solution>` against the site text; download and commit any
  solution images referenced.

### PreTeXt XML structure for an Investigation

The condensed skeleton below shows the overall shape (follow `inv-5-1.ptx` for the exact,
approved formatting and the conventions above):

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
- `ptx-lint` — pre-push lint/validate workflow: runs `scripts/ptx_lint.py`, a real build, and
  (optionally) `pretext validate`, and explains how to interpret each finding and the
  fatal-vs-non-fatal build output.
- `view-build` — visually inspect a rendered page (screenshot → view) to confirm formulas/images/
  tables render; requires the optional Playwright install (setup step 5).

Helper scripts in [`scripts/`](scripts/):
- `ptx_lint.py` — the repo-specific linter (dangling xrefs, image case/existence, dotted labels,
  `<p>`-wrapped lists, orphaned files).
- `extract_docx.py` — dump Word-doc paragraph text for verbatim fidelity diffs.
- `setup-jing.ps1` — one-time shim so `pretext validate` finds a `jing` validator.
- `screenshot_build.py` — render a built page to PNG for visual QA (needs Playwright; see the
  `view-build` skill).

## Key Reference Docs in This Repo

- [RUNESTONE-DEPLOYMENT.md](RUNESTONE-DEPLOYMENT.md) — Deployment guide and Sage cell usage notes (see caveat above about the external-URL claim).
- [CONVERSION-SUMMARY.md](CONVERSION-SUMMARY.md) — History of the book structure conversion (as of Nov 2025; structure has since evolved further — treat as historical context, not current state).
- [MarkdownTranslation.md](MarkdownTranslation.md) — Conversion best practices (currently just: use current PreTeXt exercise formatting, not legacy Runestone formatting).
