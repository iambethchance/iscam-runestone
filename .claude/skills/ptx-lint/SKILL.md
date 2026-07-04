---
name: ptx-lint
description: Pre-push lint/validation for the ISCAM PreTeXt book. Run before committing/pushing to Runestone to catch build-breakers and "works locally, breaks online" issues — dangling xrefs, missing/wrong-case images, dotted labels, deprecated markup, orphaned files — plus a real build and (optionally) strict schema validation. Use when the user asks to lint, validate, check, or "is this safe to push?", or proactively before you commit .ptx changes.
---

# ptx-lint

A layered check for this repo. The layers exist because **`pretext build` alone is not a
sufficient gate**: it reports most problems as non-fatal `PTX:ERROR` lines (build still
"succeeds" and deploys), and Runestone's server runs a *newer* pretext than the local pin, so
some things that only warn (or pass) locally can render wrong or error server-side. See CLAUDE.md
"Platform background" and the deployment notes for the version-drift context.

Run all three layers from the repo root with the venv active.

## Layer 1 — repo-specific linter (fast, always run)

```bash
uv run python scripts/ptx_lint.py
```

Exit code 1 = ERROR-level findings exist. What it catches and how to treat each:

- **`[dangling-xref]`** — `<xref ref="X">` with no matching `xml:id`/`label` in the files
  actually included from `main.ptx`. **This is the one that makes `pretext build` fatally fail**
  (`critical:` … "does not point to any target"). Always fix before pushing: either the target
  file isn't `xi:include`d in `main.ptx`, the id is misspelled, or the target was removed.
- **`[image-missing]` / `[image-case]`** — `<image source>` pointing at a file that isn't in
  `assets/`, or that differs only in case. **Case mismatches are the classic silent
  local-vs-Runestone break**: Windows/Mac filesystems are case-insensitive so the image shows
  locally, but Runestone's Linux server is case-sensitive and the image 404s. Fix the source
  attribute or rename the asset so the case matches exactly.
- **`[dup-xml:id]`** — same `xml:id` defined twice; makes xref targets ambiguous. Rename one.
- **`[missing-include]`** — `main.ptx` (or a child) includes a file that doesn't exist.
- **`[dotted-label]`** — `label="I5.6.a"` style values with periods. pretext ≥ ~2.40 (i.e.
  Runestone's server) rejects these as invalid labels. **This is currently book-wide (900+ of
  them) and non-fatal**, so do NOT try to fix them all as part of an unrelated change — but never
  ADD new dotted labels, and flag it if the user wants a dedicated cleanup pass (labels →
  hyphens/underscores). Cross-references use `xml:id`, not `label`, so a careful global
  `.`→`-` rewrite of label values is low-risk but should be its own reviewed commit.
- **`[p-wraps-list]`** — a `<p>` directly wrapping a `<ul>`/`<ol>` (deprecated block-in-inline;
  the list must be a sibling of `<p>`, not a child). Same defect earlier sessions cleaned up in
  ch2. Fix by unwrapping the list.
- **`[orphan-file]` (warn)** — `.ptx` under `source/` not reachable from `main.ptx`. Mostly
  intentional backups (`*-backup.ptx`, `*-old.ptx`, `main-*.ptx`) — but this list is also how you
  notice a genuinely-finished investigation that was never wired in (e.g. `inv-5-7/8/9` exist but
  aren't included, which is *also* why their xrefs dangle). Don't auto-delete; surface to the user.
- **`[image-parens]` (warn)** — parentheses in an image filename (repo convention forbids them).

Report ERROR findings grouped by type with counts; don't dump 900 identical dotted-label lines at
the user — summarize ("940 dotted labels, book-wide, pre-existing, non-fatal") and list the
handful of findings that are actually new or actionable for the current change.

## Layer 2 — real build (the practical deploy gate)

```bash
pretext build runestone   # this is the target Runestone actually builds
```

Interpreting output (this distinction matters a lot):
- **`critical:` … "Failed to build without errors"** → FATAL. The build stopped; must fix. In this
  repo the usual cause is a dangling xref (Layer 1 will have already pointed at it).
- **`* PTX:ERROR:` / `* PTX:BUG:` lines without a trailing `critical:`** → non-fatal. The build
  still produced output. Known-tolerated noise here includes dotted-label errors and
  `hN template … aside` BUG lines. Note them, but they don't block a push on their own.

If you changed one file, `grep` the build log for that file's ids/content to confirm *your* change
didn't introduce a new error, rather than reading all 1900+ noise lines.

## Layer 3 — strict schema validation (optional, deeper)

```bash
pretext validate
```

Requires a `jing` validator on PATH backed by Java (one-time setup:
`powershell -File scripts/setup-jing.ps1`, and a JRE installed — see CLAUDE.md). This is the
strictest check and will flag things the build tolerates. **Caveat for this book:** the whole book
uses `<exercises>` as a container holding `<p>`/`<paragraphs>`/`<assemblage>`/`<tabular>` children,
which the RELAX-NG schema does NOT permit, so `pretext validate` emits large numbers of
"element … not allowed here" errors for that pattern across every investigation. That is a known,
book-wide, build-tolerated deviation — don't treat those specific errors as a regression from your
change, and don't rearchitect a single file's `<exercises>` to be schema-pure in isolation (it
would make that investigation inconsistent with all its siblings). Use Layer 3 mainly to spot
*new* structural mistakes in files you touched (a mistyped tag, a truly malformed nesting), by
diffing its output against a baseline run on `master`.

## Recommended pre-push flow

1. `uv run python scripts/ptx_lint.py` — fix all ERROR findings that your change introduced or
   touched; note (don't necessarily fix) the pre-existing book-wide ones.
2. `pretext build runestone` — confirm no `critical:` failure and no new `PTX:ERROR` for your file.
3. (When in doubt on structure) `pretext validate` and compare to baseline.
4. Commit small and push; then check the "view latest log" link in Runestone's author interface
   after the server rebuild — that server log is the final source of truth for what deployed.
