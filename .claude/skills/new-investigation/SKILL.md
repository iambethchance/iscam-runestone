---
name: new-investigation
description: Scaffold a new ISCAM Investigation .ptx file (exercises, hints, solutions, practice problems) following this repo's established structure. Use when the user asks to add/create/draft a new Investigation, or convert a study/problem from the original ISCAM source into a Runestone-ready .ptx file.
---

# new-investigation

Scaffolds a new Investigation section file for the ISCAM Runestone book, matching the
structure used throughout the book.

**Reference file: `source/ch5/inv-5-1.ptx`** — this is the author-approved, Runestone-verified
formatting template. Match it. Before writing, read CLAUDE.md's "Runestone formatting conventions"
section (no `(a)`/`(b)` prefixes; `xml:id` only on main exercises, no `label`; Study Conclusions
needs `xml:id="study-conclusions-N-M"`; cross-refs via `<xref … text="custom">Question N</xref>`;
practice problems in a `<subsection>` outside `<exercises>`; technology instructions as per-platform
`<hint>` reveals; `<image><description>` wraps text in `<p>`). Pull `<solution>` text verbatim from
the official solutions site (see CLAUDE.md "Pulling official solutions").

This is an authoring aid, not a code generator — most of the value is in asking the right
questions up front and then holding to the established XML conventions exactly, rather than
inventing a new shape.

## 1. Gather what you need before writing anything

Ask the user (don't guess) for whatever isn't already given in the conversation:

- **Chapter and investigation number** (e.g. "5.6") and the **title**.
- **The source study/content**: a description, a URL to the original study, or pasted text/
  Word content to convert. If converting existing material, wording should match the source
  closely (see `MarkdownTranslation.md` and CLAUDE.md) — don't paraphrase freely.
- Whether there are **practice problems** to include (most investigations have 1-2, labeled
  A/B) and their content.
- Whether any exercises need **sage R cells**, **applets/iframes**, or **images** — get the
  applet URL / image files / R code up front rather than leaving placeholders.

If the user only gives a topic and no detailed exercise list, draft a reasonable sequence of
guided exercises yourself (identify sample → identify variable → state research question →
summarize data → simulate/model → draw conclusion → study conclusions), then show it to the
user before filling in full content — the exercise *sequence* is a bigger design decision than
any individual sentence.

## 2. Figure out where the file goes

1. Look at `source/chN/` (e.g. `source/ch5/`) for the existing naming pattern in that chapter —
   it's usually `inv-N-M.ptx`, but check (chapter 5 also has `inv-5-1a.ptx`,
   `inv-5-5-applet.ptx` style variants, so confirm rather than assume).
2. Check whether that chapter uses the `chN/` subfolder pattern or a flat `ch-N-M.ptx` file at
   the top of `source/` — **grep `source/main.ptx`'s `xi:include` list** to see what's actually
   wired in for that chapter, since filenames alone are not reliable (see CLAUDE.md's
   Repository Layout section on stale/unincluded files).
3. Before writing new `xml:id` values, grep the whole `source/` tree to confirm they're not
   already used — ids must be unique book-wide, not just within the chapter.

## 3. Confirm the include point — don't silently edit main.ptx

`source/main.ptx` (or the relevant `ch-N-*.ptx`/section file it includes) is shared,
load-bearing structure. After creating the new investigation file:

1. Show the user the exact `<xi:include href="./..."/>` line you intend to add and where
   (which file, before/after which neighboring investigation).
2. Only make that edit after they confirm, unless they've already told you explicitly where it
   goes.

## 4. Template

Fill in this structure (see `source/ch1/inv-1-1.ptx` for a fully worked example, and
CLAUDE.md's "PreTeXt XML structure for an Investigation" section for the condensed version of
these rules):

```xml
<section xml:id="invN-M">
<title>Investigation N.M: TITLE</title>
<introduction>
<p><em>One short framing paragraph: what skills/ideas this investigation introduces or builds
on.</em></p>
</introduction>

<exercises xml:id="investigationN-M" hidden-label="yes">
  <title hidden-label="yes">The Study</title>

  <introduction>
    <!-- Study background. Cite the source with <url href="...">Author, Year</url>.
         Use <sidebyside>/<image> for a lead image if there is one; <aside> for supplementary
         links (e.g. videos) that aren't essential to follow the investigation. -->
  </introduction>

  <paragraphs>
    <title>Collecting the Data</title>
    <!-- Optional <assemblage xml:id="def-..."> for any new term/definition introduced here. -->
    <exercise xml:id="invN-M-a" label="IN.M.1">
      <title>SHORT IMPERATIVE TITLE</title>
      <statement>
        <p>Question text.</p>
        <hint><p>A hint that nudges without giving away the answer.</p></hint>
      </statement>
      <response/>
      <solution><p>Solution text.</p></solution>
    </exercise>
    <!-- invN-M-b, invN-M-c, ... label IN.M.2, IN.M.3, ... -->
  </paragraphs>

  <!-- Additional <paragraphs> blocks as needed. Common progression across the book:
       "Collecting the Data" -> "Summarizing the Observed Data" -> "Drawing Conclusions Beyond
       the Sample" -> "Simulation" -> "Discussion". Not every investigation uses all of these;
       follow what fits the actual study. -->

  <assemblage xml:id="study-conclusions-N-M">
    <title>Study Conclusions</title>
    <p>Wrap-up paragraph restating the finding and its scope/limitations.</p>
  </assemblage>
</exercises>

<subsection xml:id="practiceN-MA">
  <title>Practice Problem N.MA</title>
  <p>Setup paragraph for a variant/follow-up scenario.</p>
  <exercise xml:id="practice-N-MA-a" label="PPN.MA.1">
    ...
  </exercise>
</subsection>
</section>
```

## 5. Conventions to enforce while filling it in

- **Multiple-choice vs. open-response**: use `<choices randomize="yes" multiple-correct="no">`
  with one `<choice correct="yes"|"no">` per option, each with its own `<statement>` and
  `<feedback>` — write real feedback for every choice, not just the correct one. Use
  `<response/>` (+ usually `<solution>`) for open-ended/discussion questions instead.
- **Sage R cells**: `<sage language="r"><input>...</input></sage>`, XML-encode `<-` as `&lt;-`,
  explicit `print()` on every output, and repeat all setup code in each cell (cells don't share
  state — see CLAUDE.md's Interactive R Code section, including the open question about
  loading data from URLs; don't assume `data.frame()`-only without checking with the user if
  the dataset is large).
- **Images**: split between `assets/images/` (investigation-specific) and
  `assets/tech_images/` (R/JMP/Minitab output screenshots) — put new files in the matching
  folder and always add a `<description>`.
- **Applets**: `<interactive iframe="URL" aspect="W:H"/>`; check the rendered width/aspect
  rather than assuming the default is right.
- **xml:id** kebab-case and unique book-wide; **label** format
  `I<chapter>.<investigation>.<n>` for main exercises, `PP<chapter>.<investigation><letter>.<n>`
  for practice problems.

## 6. Before handing back

- Run `pretext build runestone` and check for new warnings/errors attributable to the new file.
- Tell the user the file path created, the include line (and whether you added it or are
  waiting on confirmation), and any open questions you deferred (e.g. missing images, applet
  URLs, or dataset source).
