# Content Fidelity Report — Runestone vs. `iscam4_RJMPFall26.pdf`

**Date:** 2026-07-18 · **Gold source:** `source/iscam4_RJMPFall26.pdf` (423 pp, ©2026)
**Scope:** every content file included from `source/main.ptx` (Preliminaries + Chapters 1–5, ~92 files), compared question-by-question against the PDF. `<solution>` blocks were skipped (instructor-key content). Expected conversion differences were **not** reported: stripped (a)/(b)/(c) prefixes, auto-numbering/xref phrasing, per-platform hint-reveal restructuring of Technology Detours, intentional Minitab removal, added `<sage>` R cells, embedded applets, layout/encoding markup.

**Status: COMPLETE** — all chapters compared.

> **Update (2026-07-18):** Per the author, Investigations 5.1, 5.1A, 5.2, 5.3, 5.4, 5.5 (+ ANOVA applet page), and 5.6 have been **restored to PDF-verbatim wording** (scaffolding/MC conversions kept; answer-revealing content removed; the chi-square summary's "at least one πᵢ" fixed). Their findings below are retained as the historical record. Still open by design: Inv 5.1A's collapsed 2×2 table keeps the corrected 701/1844 (PDF prints 645/1854, which is arithmetically inconsistent — author decision pending), and the "Follow-up analysis" paragraph added to `chi-square-test-summary.ptx` is left in place pending author decision.

*PDF page numbers below are file pages (printed page + 1).*

## Top-priority findings (author attention first)

1. **Investigation B (`inv-b.ptx`) was substantially rewritten** — roughly a dozen PDF questions missing, merged, or replaced. Needs a full restoration pass.
2. **Two mathematically incorrect statements introduced:** the Wald-interval percentile lost its minus sign in both `summary-1-14.ptx` and `summary-3-1.ptx` ("−z\*" → "z\*"); and `inv-5-7.ptx` reversed "−1 or 1" so r = 1 is paired with negative slope.
3. **Missing questions:** Inv 1.9 (g) construct/interpret the 95% CI; Inv 4.8 (g) sketch power curves; Inv 5.5 (c) by-hand F-statistic + sketch; several sub-questions elsewhere (see per-file lists).
4. **Missing content blocks:** Inv 4.2's two Technology Detours (Selecting Independent Random Samples; Unstacked data) exist nowhere in `source/`; `prob-detour-normal.ptx` lacks the 68–95–99.7 figure; Ch 1 wrap-up procedures table is missing rows/conditions.
5. **Chapter 5 LLM-compression legacy:** heavy paraphrase/compression in `ch-5-intro.ptx`, `inv-5-1.ptx`, `inv-5-1a.ptx`, `inv-5-2.ptx`, `inv-5-3.ptx`, `inv-5-4.ptx`, `inv-5-6.ptx` (Study Conclusions); plus an invented transition paragraph in `inv-5-10.ptx`.
6. **Exercises that give away answers:** `inv4-11-h` prints the hypotheses it asks for; `inv-5-5` tech hints include a "Solution" hint (F = 29.2, which also contradicts the correct 31.48); pre-filled answer tables in `inv2-8-c` and `inv-5-1a`; answer-stating hints in several files.
7. **Changed numbers vs. the PDF:** Inv 5.1 (k) equation components; Inv 5.4 (i) means rounded; Super Bowl years (Inv 2.1 practice); NBA season year (Inv 4.2); 3.3% → 3.5% (Inv 2.1); 2026 → 2025 senators (Inv 1.18); t = −5.46 → 5.46 and −1.73 → 1.73 (Inv 2.5); Inv 5.1A's 2×2 table (645/1854 → 701/1844 — PDF itself arithmetically inconsistent; author decision).
8. **Broken/wrong references and URLs:** stale "Checkpoint" strings (Ex 1.2, Practice 2.2A, Practice 2.4A, Practice 5.2); wrong xref targets (inv 1.3, 1.7, 1.11, 1.12, 2.2, 2.4, 4.5); `/applets/2021/test/` debug applet URLs (inv 3.5, 3.6, 3.8); iscam2/iscam3-vs-iscam4 data-URL mismatches; a broken relative `href="tech-detour-two-way.html"` in inv-4-7; `fisher.test` → `fmsb::oddsratio` swap in `inv-3-9-summary.ptx`; R function renamed `is.chisqprob` in inv-5-1.
9. **Markup defects found while comparing:** `correct="yes"` on `<statement>` instead of `<choice>` in all three PP1-11E exercises; malformed xref in `I1-12-h`; stray U+FFFC characters in inv-3-1; missing `xml:id="study-conclusions-5-4"` (green box styling) and a `inv5-1-…` xml:id in inv-5-4.

---

# Section 1 — Significant / material differences or omissions

## Preliminaries

### `source/frontmatter.ptx`
- PTX contains an entire second preface, "Using Technology with This Book" (Interactive Applets, Interactive R Cells, RStudio, Data Files, JMP), that does not exist in the PDF (pp. 1–4). Likely an intentional Runestone addition, but it is PTX-only content.

### `source/ch-0-prelim.ptx`
- Chapter `<introduction>` sentence "These preliminary investigations introduce key concepts that will be used throughout the course." is not in the PDF.

### `source/inv-a.ptx` (Investigation A)
- **Section retitled:** PDF "Investigation A: Hurricanes and Climate Change" → PTX section title "Investigation A: Distributions and Variability" (inner exercises title keeps the PDF title; TOC/page heading differs).
- **Changed count:** PDF p8 says "three key features" (then lists four bullets — a source typo); PTX says "four key features". Silent change to source wording; author should confirm intent.
- **Practice Problem A.A workflow rewritten:** PDF's copy-data-to-clipboard instructions (incl. the bracketed "Alternatively, this dataset is listed in the Select data pull-down menu…") replaced by "type `AtlanticStorms.txt`. Press the Use Data button (twice)."
- **Missing image:** PDF p9 dotplot screenshot (n = 173, Mean 5.538, Median 5) in the mean/median Definitions box — the corresponding `<figure>` is commented out in PTX.
- **Added content not in PDF:** hints on essentially every exercise; auto-graded fill-ins with feedback; practice questions (a)/(b) converted from open response to multiple choice.

### `source/inv-b.ptx` (Investigation B) — heaviest rewrite found in the Preliminaries; needs a full restoration pass
- **Section retitled:** PDF "Random Babies" → PTX section title "Investigation B: Randomness and Probability".
- **(a) meaning changed:** PDF asks to predict how often ≥1 mother and all four mothers get their own baby over many nights; PTX asks "what do you think is more likely… no mothers… or all four…?"
- **Missing PDF questions** (roughly a dozen dropped, merged, or replaced):
  - (b) single-trial "How many mothers received the correct baby: 0 1 2 3 4"
  - (c) "Did everyone in class obtain the same number of matches? If not, why not?"
  - (d) class pooling with the Number-of-matches/Count/Proportion tally table
  - (e) "One outcome is actually impossible… Which… why?" (replaced by a different question)
  - (f) proportion of trials with ≥1 match from class data (with two-ways hint)
  - (h) "How could we improve our estimate…?" (replaced by a non-PDF question)
  - (j) full 0–4 proportions table after 1000 trials (PTX asks only for zero-matches)
  - (k) sub-question "Do all of your classmates obtain the same estimate?"
  - (l) weighted-average of number of matches (∑xᵢfᵢ/N hint) — missing entirely
  - (m) "Select the Average radio button… describe the behavior" — missing entirely
  - (q) exact P(X = 0) computation + comparison to simulation as its own question
  - (t) "What is the sum of these five probabilities? Why does this make sense?"
  - (u) two-ways hint and "How does this compare to the simulation results?"
  - (v) "Comment on how it compares to the average value from part (l)"
  - (w) "Is the expected value equal to the most probable outcome?…" (replaced)
  - (y) "Confirm that the value of the standard deviation makes sense…" (replaced by a 10,000-trial simulation question not in the PDF)
- **Definition box truncated:** final sentence about independent / identically distributed observations missing from `def-random-process`.
- **(r) table changed:** PDF asks probabilities as fractions *and* decimals (two-row table); PTX has a one-row table, fraction row dropped.
- **Factorial discussion demoted:** PDF body text ("4×3×2×1 = 24… '4 factorial'") buried inside a hidden hint.
- **PTX-only questions added:** define-the-random-variable question; several others; extensive auto-graded numeric answers with worked feedback.

### `source/inv-c.ptx` (Investigation C)
- **Section retitled:** PDF "Modelling Hurricanes" → PTX section title "Investigation C: Modelling".
- **Practice C.A (a) task changed:** PDF's "Include a screen capture of your random process." replaced by "Describe your model below."; the pie-chart instruction wording also rewritten.
- **Added content not in PDF:** hints on several exercises; a "Conjecture:" prefix; one question converted to two-option multiple choice with no per-choice feedback.

## Chapter 1

### `source/ch-1-intro.ptx`
- PDF p20 lists "Probability Detour: Binomial Random Variables" (after Inv 1.2) and "Probability Detour: Binomial approximation to Hypergeometric distribution" (after Inv 1.15) as contents lines — both missing from the PTX contents listing.

### `source/ch-1.ptx`
- The Section 1 landing paragraph from PDF p21 is not used; the `<introduction>` instead repeats the chapter-intro paragraph, which the PDF does not place there. (The PDF paragraph was relocated into inv-1-1.ptx's introduction.)

### `source/ch1/inv-1-1.ptx`
- **Technology Detour — Bar Graphs substantially condensed** (PDF pp22–24). Missing: R summary-data variant (`barplot(c(14, 2), …)`); R Graphics-window/export note; JMP summary-data Graph Builder option; the entire "Creating a bar graph in JMP (raw data)" block (both options + formatting notes); "Best when using the Drop zone for rows."
- **"Handy Reminders" box missing entirely** (PDF p24: R `?barplot` tip; JMP hot spots / Preferences / ISCAM Journal file).
- **URL mismatch:** JMP hint links InfantData.txt at `iscam2/data/` while the PDF and other references use `iscam3/data/`.
- PTX-only additions: aside with three YouTube video links; per-question hints on most exercises.

### `source/ch1/inv-1-2.ptx`
- PTX-only framing line in the introduction; PTX-only "R Reminder" and "JMP Reminder" paragraphs inside the binomial Technology Detour; added hints/asides with no PDF counterpart.

### `source/ch1/inv-1-3.ptx`
- **Cross-reference mistarget:** PDF (p) compares to (j) (theoretical mean/SD = `I1-3-10`), but PTX xrefs "Question 11" (`I1-3-11`, Verify Calculations).
- PTX-only framing line and "Type 'pi'…" tips.
- Flag: added ESP image referenced as `source="esp.png"` living at `assets/esp.png` (outside `images/`/`tech_images/`), unlike every other image.

### `source/ch1/inv-1-4.ptx`
- R instructions drop two PDF sub-bullets under `observed` ("…table(NamesData)"; "value less than one… assumes proportion") and the "from the ISCAM Workspace" qualifier.
- PDF (g)'s "(including appropriate notation for the event of interest)" requirement dropped (original exercise commented out).
- PTX-only framing line, "R Reminder" paragraph, added hints.

### `source/ch1/inv-1-5.ptx`
- **Retitled:** PDF "Butter-Side Down Again?" → PTX "Buttered Side Down Again?"
- PTX-only framing lines in the introduction.

### `source/ch1/inv-1-6.ptx`
- PDF p49 (e) note dropped: "Note: We can use the symbol p̂ to refer to a sample proportion."
- PDF (g): zoom-to-three-decimals hint gone (original exercise commented out, replaced by checkbox exercise).
- PDF (c) and (d) merged into one matching exercise, dropping "for investigating this ad's claim".
- JMP/R confidence-interval hints add worked kissing-example values not in the PDF detour.

### `source/ch1/inv-1-7.ptx`
- **Hard-coded xref error:** applet bullet says "Enter the first value from question 15" — should be Question 13 (`I1-7-m`); also missing the word "in" and not an `<xref>`.
- Added framing paragraph and many hints with no PDF counterpart (some give the answer away).

### `source/ch1/inv-1-8.ptx`
- **R argument strings changed from the PDF:** PDF detours say `alternative = "below," "above," or "two.sided"` (both the z-test and continuity-correction detours); PTX uses `"less"`, `"greater"`. Not verbatim to the PDF (verify which matches the current iscam functions).
- Substantial added detour content (worked Halloween steps/outputs) not in the PDF; added framing sentence; hints on nearly every exercise.

### `source/ch1/inv-1-9.ptx`
- **Missing question — PDF p69 (g):** "Then use this multiplier to construct and interpret a 95% confidence interval for π." No PTX exercise asks this (the detour exercise only confirms the earlier multiplier-2 interval).
- Missing lead-in sentence before the Wald-interval box ("Putting these together, we have a one-sample z-interval (aka Wald interval)…") and the "We will use technology to do this." sentence.
- Applet detour instruction changed: PDF "Change the confidence level from 95 to 90%" → PTX "Change the confidence level to 95%" (detour repurposed/moved).
- Added worked-technology content and many hints not in the PDF.

### `source/ch1/inv-1-10.ptx`
- PDF (b) "(Show the values substituted into the formula.)" dropped.
- PDF (e) "Why or why not?" dropped; "How can you tell?" replaced with an answer-revealing parenthetical.
- PDF (n) "(Pick one.)" changed to "method(s)" with two correct answers, and Wald not offered as a choice.
- **URL/name mismatch:** hint text says "Theory-Based Inference applet" but links the One Proportion applet (`OneProp.htm?hideExtras=2`).

### `source/ch1/summary-1-10.ptx`
- (Text matches; see Drift for an introduced grammar error.)

### `source/ch1/inv-1-11.ptx`
- PDF (b)/(c) sketch instructions dropped ("sketch the predicted behavior of the null distribution"; "Draw a sketch of the null distribution").
- **Wrong xref:** (j) hint should point at (g) (π = 0.35 power, renders as Question 8); PTX links `I1-11-f` labeled "Question 7" — wrong target and wrong number.
- **Markup defect:** in all three PP1-11E exercises, `correct="yes"` sits on `<statement>` instead of `<choice>` — no choice is registered correct.
- Applet UI term changed: PDF "Number of samples" → PTX "Number of repetitions".

### `source/ch1/activity-1-12-data.ptx`
- PDF p85 (a) "Circle 10 **representative** words…" and the full printed Gettysburg Address passage are not reproduced; replaced by the getWordsR.html applet + class-id instruction. The word "representative" (pedagogically load-bearing) does not appear in the activity text.

### `source/ch1/inv-1-12.ptx`
- **Missing sub-question** (PDF p87 (g)): "Is your sample proportion similar to the population proportion?"
- PDF (b) framing dropped: "(if the sample is truly representative, it shouldn't matter what variable I end up recording)" + Record Y/N instruction + the 10-column Word/Short? table.
- PDF (m) recording task dropped: "Write down the resulting ID numbers, the selected words, and whether the word is short." + the 5-column table.
- R detour note dropped (up-arrow repeat / `rm(.Random.seed)` reset).
- Printed numbered sampling frame replaced by a link.
- **Wrong hard-coded xref:** `I1-12-n` says "Question 11" for `I1-12-h`, which renders as Question 13.
- **Malformed xref:** `I1-12-h` has `<xref ref="I1-12-g" text="local">Question </xref>` — literal "Question " with no number.

### `source/ch1/summary-1-14.ptx`
- **Dropped minus sign changes the math:** PDF Wald interval: "where **−z\*** is the 100 × (1 − C)/2th percentile…" → PTX says "z\*" is that percentile — mathematically incorrect as written.

### `source/ch1/inv-1-15.ptx`
- PTX-only framing sentence; PTX-only added exercise (`I1-15-g` "Report the p-value (4 decimal places)").
- Cosmetic bug: stray `<xref ref="I1-15-g">` at the top of `I1-15-i`'s solution renders an orphan "Question 11".

### `source/ch1/inv-1-16.ptx`
- PTX adds question text not in the PDF on (g)/(h) ("What is the total number of Landon votes?"; "…report the **nubmer** of Roosevelt votes" — misspelled "number").

### `source/ch1/inv-1-18.ptx`
- **Year changed:** PDF Discussion "the population of the **2026** U.S. Senators" → PTX "**2025**" (intro and (d) correctly say 2026).

### `source/ch1/prob-detour-normal.ptx`
- **Missing figure:** the PDF p66 empirical-rule graphic (68%/95%/99.7% shaded curves) is absent; only the single normal-curve image is present.

### `source/ch1/section-wrap-up.ptx` (incl. Examples 1.1–1.3)
- **"Choice of Procedures" table, Study design row:** PDF "One binary variable, constant probability of success, independence" → PTX keeps only "One binary variable" — the two conditions dropped.
- **Missing table rows:** PDF p126 has *two* R-Commands rows and *two* JMP rows (after "Exact p-value" and after "Confidence interval"); PTX consolidates to a single pair — second pair absent.
- **Hard-coded stale xref text in Example 1.2:** visible strings "Checkpoint 6.2.3" / "Checkpoint 6.2.6" instead of "Question 3"/"Question 6"-style refs; won't track auto-numbering.
- Minor additions: wrap-up intro sentence; stray "Datasets and Applets page" link line in example-1-2; "Watch video walkthrough" links on all three examples (presumably intentional).

## Chapter 2

### `source/ch2/inv-2-1.ptx`
- **"Accessing quantitative data" pointer paragraph replaced:** PDF's short pointer + "R Notes"/"JMP Notes" sentences replaced by a long 4-method R import guide not in this PDF; the R/JMP Notes sentences omitted entirely.
- **Changed statistic in Discussion:** PDF "a normal distribution predicts **3.3%** of babies will be of low birth weight" → PTX "**3.5%**".
- **Changed years in Practice 2.1B:** PDF "1980 (Super Bowl 14) to **2026 (Super Bowl 60)**" → PTX "to **2025 (Super Bowl 58)**" (also internally wrong — 2025 would be SB 59).
- Practice 2.1B (a): added sentence "Report your axis labels and your title." not in PDF.
- Probability-plot explanation condensed: 1/nth-percentile mechanism and "easier to judge" sentences lost from visible text.
- PDF dotplot-description sentence demoted into a hidden solution; R "attach" note sentence dropped.
- Added framing paragraph, added JMP hint on (h), added qqnorm/qqline lines in Practice 2.1C hints.
- URL flag: "User's Guide for 2024" links to `UserGuide2023.pdf`.

### `source/ch2/inv-2-2.ptx`
- **Retitled:** PDF "Investigation 2.2: How Long Can You Stand It?" → PTX "Investigation 2.2: Honking Reaction Times" (chapter-intro list still uses the PDF title — internally inconsistent).
- **Missing question part** (PDF (c)): "Why is it larger?" — only the MC "Which is larger?" remains.
- **Wrong cross-references:** PTX `inv2-2-l` points at (h)/(i) ("Question 12"/"Question 13"); PDF says repeat **(j) and (k)** — should target `inv2-2-j`/`inv2-2-k`.
- **Stale hard-coded ref:** Practice 2.2A (c) shows "Checkpoint 8.2.1" (not an xref; wrong for current build) where PDF says "based on the first graph you looked at in part (a)".
- URL flags: honking.txt links to `iscam2/data/` (text says iscam4); 30seconds.txt links to `iscam3` (text says iscam4).

### `source/ch2/inv-2-3.ptx`
- (No material issues — all content verbatim; see Drift for added method-revealing hints.)

### `source/ch2/inv-2-4.ptx`
- **Introduction substantially rewritten with facts not in this PDF** (20 drowned / 174 lbs avg / 140 lbs design assumption / NY State Police 2006); the PDF's framing sentences gone. May originate from an older ISCAM edition — confirm before fixing.
- **Question (a) replaced:** PDF's conjecture-sketch of 47 weights (+ guesses of x̄ and s, Empirical-Rule hint) replaced by a different boat-to-boat variability question.
- **Question (b) deleted and answered for the student:** PDF's "sketch a possible distribution" converted to body text + a supplied figure with an added normal-shape assumption sentence.
- **Wrong xref:** `inv2-4-n` references (l) ("Question 11"); PDF says "the question posed in **(m)**".
- **Added Key-Result content not in PDF:** skewness → minimum-sample-size table (0.25→10 … 2.0→165) plus its lead-in sentence.
- (r) table row labels trimmed: distribution parameter values (μ = 167, σ = 35; a = 106.4, b = 227.6) dropped.
- **Stale hard-coded ref:** Practice 2.4A (d) shows "Checkpoint 9.1.1" where PDF says "the calculation in (a)".
- Added answer-leading hint on (g); PDF's (g) lead-in sentence dropped.
- URL flag: `NormCalc.htm` (elsewhere `NormCalc.html`) — likely broken.

### `source/ch2/inv-2-5.ptx`
- **Retitled:** PDF "Healthy Body Temperatures" → PTX "What is a healthy body temperature?"
- **Sign dropped in Study Conclusions:** PDF "(t = **−5.46**, two-sided p-value < 0.001)" → PTX "t = 5.46".
- **Sign dropped in (l):** PDF "as extreme… as the observed value of **−1.73**" → PTX "1.73".
- (v)'s "Is this what you expected? Explain." converted into a hint that states the answer outright.
- Added sentence "We have created a population distribution of **20,000** body temperatures" — not in PDF and conflicts with Practice 2.5C's 10,000.
- Added JMP Distribution-Calculator line not in PDF.

### `source/ch2/inv-2-6.ptx`
- **Added intro recap paragraph not in the PDF** (verified visually: PDF p158 starts directly with (a)).
- **Contradictory auto-grading on `inv2-6-b`:** the added `<setup>` expects 96.783/99.715 (= 98.249 ± 2·0.733), but the question (verbatim PDF) says use μ = 98.6 — correct answer (97.13, 100.07) would be marked wrong.
- Added hints on (e)/(j) not in PDF; added Practice 2.6A intro sentence.

### `source/ch2/inv-2-7.ptx`
- Added question sentence on (c) not in PDF ("Is there a tendency for the dissolved oxygen levels to be below the standard?").
- Added heading "Alternative analysis: Proportion non-compliant" not in PDF.

### `source/ch2/inv-2-8.ptx`
- **Fill-in table pre-filled with answers:** PDF (c)'s blank Mean/Log(mean)/Mean(log) table is presented already completed (100.3 / 4.608 / 4.301 / 75.5 / 4.324 / 4.324) — compute task became read-the-answers. Header changed "Log" → "Ln".
- **Data-file URL inconsistencies:** MermentauTurbidity `href` → `iscam3/data/` while visible text says `iscam4/data/`; the (a) aside applet loads `turbidity.txt` (different filename than the PDF's `MermentauTurbidity.txt`). Verify what resolves.
- Added aside (log base) and back-transform hint not in PDF.

### `source/ch2/inv-2-9.ptx`
- (No material issues — content verbatim incl. all technology wording; see Drift.)

### `source/ch2/sec-2-summary.ptx`
- **Technical conditions expanded beyond the PDF:** PTX appends "; and the data are independent and identical observations from a random process or are from a large population (N > 20n)" to the t-procedures validity sentence, and "(from random process or large population)" to the PI box — neither clause is in the Fall26 PDF.
- Typo introduced: "Specify the summary statisti" (missing "cs").

### `source/ch2/section-wrap-up.ptx` (incl. Examples 2.1–2.2)
- Both worked Examples present and verbatim (incl. full driving.txt table, all 32 values verified).
- **Choice of Procedures table:** PTX adds a second bullet "Large population or random process" to the "Can use t procedures if" row — not in PDF p178.
- Added intro sentence and per-example "Watch video walkthrough" YouTube links not visible in the PDF body (presumably intentional).

## Chapter 3 (part 1 — Inv 3.1–3.6; part 2 pending)

### `source/ch-3-1.ptx`
- PTX introduction sentence not in the PDF (PDF has only the bare SECTION 1 heading).

### `source/ch-3-3.ptx`
- Structural note: ch-3-3.ptx also includes inv-3-8/3-9/3-10, which the PDF places under a separate "SECTION 4: OTHER STATISTICS" — the PDF's Section 4 heading level is absent from the book structure.

### `source/ch3/inv-3-1.ptx`
- Segmented Bar Graphs R hint drops the "(margin = 1 for row proportions…" half of the PDF parenthetical.
- Two stray U+FFFC object-replacement characters ("￼") at lines 517–518 — paste artifacts that may render as empty boxes.
- Tech Detour – Simulating Proportions: the PDF's pointer lines (applet name + IndependentBinomialsR/JMP.html) are gone; PTX inlines full R/JMP content that cannot be verified against this PDF; the applet pointer line dropped entirely.
- z-procedures R hint: PDF's "Optional:" markers dropped; PDF's literal example call replaced (and `conf.level= 95` → `0.95`).
- Structural reorder of detours/practices relative to the PDF (content present but relocated).
- Practice 3.1A: added exercise statement not in the PDF.

### `source/ch3/summary-3-1.ptx`
- **Dropped minus sign changes the math:** PDF "where −z\* is the 100 × (1 − C)/2th percentile…" → PTX "z\*" (same defect as summary-1-14).
- **Adjustment method renamed:** PDF "the Wilson or Wald adjustment" → PTX "a 'plus four' (1 success and 1 failure in each group) adjustment" — different terminology/technical content.
- Technical conditions changed from strict to non-strict: PDF "> 5" → PTX "≥ 5" throughout.

### `source/ch3/inv-3-2.ptx`
- (No material issues; see Drift. Minor: aside link's visible text shows the NormCalc URL while the href is the TBIA applet.)

### `source/ch3/inv-3-3.ptx`
- **(a) question sentence omitted:** "Identify the explanatory and response variables in this study." — only the "Explanatory:/Response:" fill-in labels remain.
- **(o) second half dropped:** "…or is there a tendency for one group to always have higher amounts of sleep? Explain."
- PTX-only introduction framing sentence.

### `source/ch3/inv-3-4.ptx`
- (No material issues — verbatim throughout.)

### `source/ch3/inv-3-5.ptx`
- **Applet iframe uses a "/test/" development URL** (`/applets/2021/test/ChiSqShuffle.htm?dolphins=1`) while the text link uses the stable path — iframe likely pointing at the wrong/unstable URL.
- PDF (j) "Pool your results… produce a well-labeled dotplot…" demoted to a plain paragraph — no exercise/answer box (ids skip i → k).
- PTX-only aside: "Randomization Animation" GIF (likely intentional; for the record).

### `source/ch3/inv-3-6.ptx`
- PDF (e) applet bullet "Generate a randomization distribution for this statistic." dropped from the bullet list.
- **Applet iframe again uses the "/test/" dev URL** (`?yawning=2`) while the text link uses the stable path (`?twobytwo=1` — note the two links also disagree on parameters).
- PTX-only additions: framing sentence; extended intro sentence ("while leading to a third room"); hint on (h) that answers the question the PDF asks; added follow-up Yes/No on (m); extra Technology-Detour lead-in and applet bullets beyond the PDF.

### `source/ch3/inv-3-7.ptx`
- **(g) hint instruction changed in meaning:** PDF "Use the Analyzing Two-way Tables applet **to compare the normal approximation to Fisher's Exact Test**" → PTX "Use **simulation** in the… applet **to adjust the count samples box**" — a different applet action.
- Added hint on (e) not in the PDF ("…check a box to Show z-test output.").

### `source/ch3/inv-3-8.ptx`
- **(j) instruction dropped:** "Describe the shape of this distribution." (remaining question converted to bare Yes/No MC).
- Theoretical Result box omits the PDF's small 2×2 margin table (equivalent appears only in inv-3-8-summary).
- **Applet aside uses the `/applets/2021/test/` debug URL** (PDF annotation: `applets/ChiSqShuffle.html?FET=1`).
- Added hint on (g) not in the PDF.

### `source/ch3/inv-3-8-summary.ptx`
- Technology list adds an applet bullet not in the PDF's RR box (possibly harmonization with the OR box, but added content).

### `source/ch3/inv-3-9.ptx`
- URL mismatches vs the PDF's link annotations: Widom 1989 citation (ojp.gov vs psycnet.apa.org) and Practice 3.9A(d) applet query (`?twobytwo=1` vs `?FET=1`).

### `source/ch3/inv-3-9-summary.ptx`
- **Dropped from the p-value entry:** "You can also use simulation (assuming the probabilities of success are equal) or…"
- **R command swapped:** PDF "fisher.test(matrix(c(a, c, b, d), nrow=2), alt = )" → PTX "install the fmsb package… `fmsb::oddsratio(…)`" — the summary now disagrees with both the PDF *and* inv-3-9's own hint (which uses fisher.test).
- Added content not in the PDF: "(or ln(τ) = 0)" hypothesis augmentations and a 5-row invariance-property table.

### `source/ch3/inv-3-10.ptx`, `example-3-1.ptx`, `example-3-2.ptx`, `summary-narrative.ptx`, `summary-what-learned.ptx`, `summary-procedures.ptx`, `summary-jmp-commands.ptx`
- No material issues (example files add ISCAM-page/video links not in the PDF — likely intentional; example-3-2's survey-question sentence is present via the intro screenshot image).

### `source/ch3/summary-technology.ptx`
- **Minitab remnant:** "Creating segmented bar graphs (R, **Minitab**, Excel)…" — verbatim from the PDF (the source itself retains Minitab here), but conflicts with the no-Minitab policy; author's call.

### `source/ch3/summary-r-commands.ptx`
- Added "Relative risk / fmsb::riskratio(…)" row not in the PDF's p246 table (duplicates procedures-table content — allowed reorganization; noted).

### `source/ch3/tech-detour-two-way.ptx`
- **PDF's R/JMP links dropped and replaced by inlined content of unknown provenance:** PDF gives "In R: RAHyperR.html / In JMP: RAHyperJMP.html" (rossmanchance.com/iscam3/data/); PTX inlines an R `rhyper` example with counts 210/4985/2584 that match no Chapter 3 study, and JMP steps built around `CPRvCC.jmp` (linked via http). Should be checked against the actual RAHyperR/RAHyperJMP pages.
- Applet URL modernized vs the PDF annotation (possibly intentional); detour relocated from mid-chapter to chapter end (pointer text in inv-3-8 updated accordingly).

## Chapter 4

### `source/ch-sec-4-1.ptx` (and orphaned duplicate `ch4/section4-1-intro.ptx`)
- **Intro sentence truncated:** drops "…and then we parallel Chapter 3 in first considering random sampling and then random assignment, both for scope of conclusions but also for how we will design our simulation."
- Note: `section4-1-intro.ptx` is commented out of the build (orphaned duplicate).

### `source/ch4/inv-4-1.ptx`
- **Stemplot question restructured:** PDF's decade stems (2–6, five rows, "Laid off | stem | Retained", with worked example "add a 3 and a 5 to the 3 stem…") replaced by a nine-row split-stem table (20-24 … 60-64) with columns swapped and the example clause dropped.
- **(a) second half replaced by a different question:** PDF "Do these data seem to support the claim that the laid-off employees tended to be older…?" → PTX "…comment on whether these data provide preliminary evidence that the layoff decisions were not made at random…"
- (b): "stemplots" → "dotplots" (changes the referent — students just made stemplots).
- Added law.justia.com case-details URL not in the PDF; invented hints on all eleven exercises (PDF has none here).

### `source/ch4/inv-4-2.ptx`
- **Two entire Technology Detours from PDF p258 are missing and exist nowhere in `source/`:** "Selecting Independent Random Samples" (Applet/R/JMP) and "Unstacked data (each column is a group)" (TBIA + R `stack()` + JMP By-Conference).
- **Year changed:** PDF "start of the **2026-27** season" → PTX "**2025-26**".
- (f) summary table drops the **Skew** column.
- PDF (e) "Calculate your difference in means and pool with the rest of your class." gone — merged with (j)'s applet steps; (j)'s question text + hint dropped; an invented summary question added after the Key Result box.
- (f) second sentence changed to a different question ("Is this what you expected?" → "How does the distribution… compare to the shape of the salary distributions themselves?").
- (c): filename instruction (NBASalaries2026_2.txt paste workflow) replaced by applet-menu instructions; the filename never appears.
- Summary of Two-Sample t Procedures box appends a sentence not in the PDF ("Also consider whether you are sampling from a random process or large populations.").
- R content: comparative-graphs commands replaced by different base-R code; numerical-summaries note dropped; Probability Exploration retitled with an invented lead-in.

### `source/ch4/inv-4-3.ptx`
- (e): "Explain briefly." dropped; matching-exercise conversion gives away the answer structurally; added explanatory sentences not in the PDF.
- (a)/(b): MC conversions with invented options ("Both", "Neither", "Not really but close enough").

### `source/ch4/applet-4-3-exploration.ptx`
- No material issues.

### `source/ch4/inv-4-4.ptx`
- Note dropped: "Note: You can carry out these simulations in software as well, see the Technology Detour below."
- (h): "at least as extreme as **15.92**" → "the observed value"; MC conversion with an invented distractor.
- (l): appended "What do you learn?" (added question); (a) "Explain." dropped.
- Added "Randomization Animation" GIF aside not in the PDF.

### `source/ch4/inv-4-5.ptx`
- **Wrong visible xref label:** "(Inv 4.4(q))" rendered as "Investigation 4.4, Question 4" — inv4-4-q is the 17th auto-numbered exercise (should be Question 17).
- Practice 4.5 (a) reworded; drops "keeping in mind the goal of random assignment in general".
- (g): MC conversion with invented option/feedback text.

### `source/ch4/inv-4-6.ptx`
- No material issues in statements/tables. Borderline (inside a solution): image description "Minitab t-test output for ice cream study" — possible Minitab remnant to swap.

### `source/ch4/inv-4-7.ptx`
- Summary-statistics table drops the **N\*** and **SE Mean** columns (other nine columns match).
- **Broken link:** (g) lead-in links "Technology Detour in Investigation 4.4" to relative `href="tech-detour-two-way.html"` — broken in the built book; should be an `<xref>`.
- Back-transform discussion formulas changed symbols: PDF's μ₁/μ₂ → PTX x₁/x₂.
- Added "(See Investigation 2.8…)" xrefs not in the PDF.

## Chapter 4 (part 2 — Inv 4.8–4.11, Examples, wrap-up)

### `source/ch4/inv-4-8.ptx`
- **Missing question — PDF p283 (g):** "Sketch curves illustrating this power calculation." (labels jump I4-8-6 → I4-8-8). In its place PTX shows four power-curve images plus an added explanatory paragraph not in the student PDF ("The images below show the null distribution (in blue)… so the probability of rejecting the null hypothesis is small.") — drops a question *and* adds body text/figures.

### `source/ch4/inv-4-9.ptx`
- **(e) sub-question dropped:** "What does this tell you about the effectiveness of the pairing in this context?" (survives only inside choice feedback).
- **(h) meaning changed:** PDF "What do you notice about the high outliers (fastest typers) in each condition?" → PTX "How many 'high outliers'… are there in each condition? Are they related to each other?" — a different, more specific question.
- **Added exercise not in the PDF:** "Tracking the randomized values" ("What do you notice about the high outliers after each shuffle?").
- Applet renamed ("Matched Pairs Randomization applet" → "Matched Pairs applet") and an added instruction "(or type TypingMusic.txt into the data window and press Use Data twice)".

### `source/ch4/inv-4-10.ptx` and `source/ch4/summary-paired-differences.ptx`
- No material issues — verbatim (all numbers/statistics match).

### `source/ch4/inv-4-11.ptx`
- **Exercise gives away its own answer:** `inv4-11-h` prints "H₀: π = 0.50" and "Hₐ: π > 0.50" as static text in the statement where the PDF has blank answer space; the `<setup>` defines six `<var>` conditions but the statement has no `<var>` blanks — a broken fill-in conversion.

### `source/ch4/section-wrap-up.ptx` + Examples 4.1–4.4 + `summary-chapter.ptx`
- All four Examples and the Chapter Summary are present; data tables verified.
- **`example-4-4.ptx`: two added technology blocks not found anywhere in the PDF** — "Power Calculations in R" (`power.t.test(…)`) and "Power Calculations in JMP" (DOE > Sample Size Explorers walkthrough). Unverified provenance — flag for author.
- `example-4-1`/`4-2`: added `<aside>` applet-link pointers not in the PDF; `example-4-3`: added data-file link paragraph.
- Added wrapper-introduction landing text not in the PDF.

## Chapter 5

### `source/ch-5-intro.ptx`
- **Opening paragraph heavily compressed:** the PDF's ~130-word chapter intro (p315) reduced to two short sentences; most of the paragraph is missing.
- **Missing contents lines:** "Applet Exploration: Behavior of regression lines – Resistance", "Excel Exploration: Minimization criteria", "Technology Exploration: The regression effect" (all three files exist in the repo but are not listed).
- Applet Exploration entries lost their names ("Exploring ANOVA", "Correlation guessing game" → bare "Applet Exploration"; Section 3's points at inv-5-7 instead of the correlation-guessing page).
- PTX adds "Section 5.N Summary" nav lines not in the PDF listing (navigation aid).

### `source/ch5/inv-5-1.ptx`
- Missing sentence after the (b) note (PDF p317): "If the null hypothesis is true, then the long-run probability of a woman on the jury panel equals the same value for all seven judges."
- **(k) printed equation values changed:** six of the ten printed component values differ from the PDF (e.g. PDF "+1.45 + 5.53 … + 31.22 … + 0.51 + 1.95 … + 11.02" → PTX "1.43 + 5.50 … + 31.29 … + 0.50 + 1.94 … + 11.06") — PTX appears recomputed rather than transcribed.
- (n) applet bullets drop the bracketed Technology-Detour note, "Notice that the data loads in the two-way table format.", and "…confirm the segmented bar graph (which you can stretch longer)".
- **R function renamed:** PDF "iscamchisqprob" → PTX "is.chisqprob" (plus compressed input descriptions).
- Second Technology Detour compressed, retitled ("Simulating Randomization Test for Two-Way Tables" → "Simulating Sampling Distribution for Chi-Square Statistic"), relocated (before Practice 5.1 instead of after), with invented applet bullets and an invented statement sentence; R drops "1000", JMP drops the RandomBinomials hot-spot instruction.
- Missing glossary hyperlinks the PDF carries (segmented bar graph, MeanAbsDiff, chisqteststat, chisqdist, df).

### `source/ch5/inv-5-1a.ptx`
- **Verbatim survey question missing** (PDF p323): "Please rate how much you think you can BELIEVE each organization on a scale of 4 to 1… (READ ITEM: ROTATE LIST)…" replaced by a one-sentence paraphrase — and question (a) about rotating the list depends on the stripped "(READ ITEM: ROTATE LIST)". Also missing: "The interviewer then asked this question for several different news organizations."
- Intro drops "(e.g., USA Today, NPR, MSNBC)" and "in an effort to feed our impatience".
- **Fill-in table pre-filled with answers:** the PDF leaves the 2006 column blank for students; PTX pre-fills 181, 371, 261, 120, 933 while still saying "Enter your 2006 values" — gives away (c).
- **(k) changed:** PDF's "Use technology (see Technology Detour) to calculate the chi-squared statistic, verify the degrees of freedom, and calculate the p-value…" → PTX "Report the p-value. Do you reject or fail to reject…?" — compute/verify instructions dropped.
- **Collapsed 2×2 table numbers differ from the PDF:** PDF prints 645 / 1854; PTX shows 701 / 1844. The PDF's printed values are arithmetically inconsistent with the row data — PTX appears silently corrected; needs an author decision, not a mechanical fix.
- Applet detour drops "(You can expand this window by dragging out the lower right corner.)"; missing "expected count" glossary link.

### `source/ch5/inv-5-2.ptx`
- **Intro heavily compressed** (PDF p328). Missing: "as stories commonly used by teachers and parents to promote honesty, though in different ways (negative consequences of lying… vs. positive consequences of truth telling…)"; "Two hundred and sixty-eight Canadian children aged 3–7 years were recruited (children begin to tell lies around 2–3 years of age)"; "(essentially peeking at the answer when left alone in the room for one minute)"; "(The reader did not know whether or not they had peeked.)"; "After the story, the child was asked whether or not he or she had peeked."
- **Bridging paragraph after the expected-counts table compressed** to one sentence (PDF's full random-assignment-vs-random-sampling discussion dropped).
- Practice 5.2 intro compressed with meaning loss — drops "decided in advance" (the planned-comparison rationale) and the purpose clause.
- **Stale/wrong ref:** Practice 5.2 (d) says "compare to what you found in Checkpoint 5.2.c" — matches nothing in the Runestone rendering.
- Applet URL differs from the PDF's link annotation (PDF `applets/ChisqShuffle.htm` → PTX `applets/2021/chisqshuffle/ChiSqShuffle.htm?FET=1`; also plain http).

### `source/ch5/inv-5-3.ptx`
- **Missing paragraph** (PDF p331): "Note that the alternative hypothesis does not specify any particular kind of association…" (+ its lead-in sentence).
- Two bridging paragraphs compressed to single sentences (one-random-sample/cross-classified discussion; multinomial-simulation caveat "But be sure to keep the data collection methods in mind…").
- **Study Conclusions heavily paraphrased/compressed:** drops "(smallest is 14.25 > 5)", the full p-value interpretation, "overwhelming evidence", the specific confounding narrative (near-sighted parents), and the generalizability specifics (voluntary eye-doctor visits, not randomly selected).
- **Missing closing paragraph** after Study Conclusions: "You should notice that the mechanics are exactly the same whether you are testing homogeneity… The difference lies in how the data were collected…"
- Sentence referencing the two-way table / segmented bar graph dropped; confirm `images/inv-5-3intro.jpeg` is the study's segmented bar graph.

### `source/ch5/chi-square-test-summary.ptx`
- **Garbled hypothesis line:** "Hₐ: at least one πᵢ differs from the rest" → PTX "at least πᵢ differs from the rest" — "one" missing, sentence ungrammatical.
- **Added paragraph not in the PDF:** "Follow-up analysis: After computing the p-value, examine the largest cell contributions or residuals…"

### `source/ch5/inv-5-4.ptx`
- **Intro missing two full sentences** (ADA disabled-person definition; 1984 unemployment rates 7% vs 4.5%).
- Intro also drops "from a large southeastern university", both "(e.g., …)" parenthetical examples (rating questions and 1–9 scale anchors), and "in the 1980s"; the Cesare/Tannenbaum/Dalessio citation hyperlink is missing.
- **(e) drops the key word "standardized"** ("Suggest a standardized statistic…") — the later Discussion hinges on it.
- (i) table: PDF sample means 4.9, 4.429, 5.921, 4.050, 5.343 → PTX rounds to 2 dp (4.90, 4.43, 5.92, 4.05, 5.34) — changed numbers.
- **Terminology Detour relocated:** PDF places it after (y) and before Study Conclusions/practice; PTX puts it at the end of the file *inside* the Practice 5.4B subsection after its exercises.
- JMP hint adds redundant text not in the PDF ("…then Oneway Analysis > Means/Anova").
- Convention defects: tech-detour xml:id says `inv5-1-…` (should be 5-4); Study Conclusions assemblage lacks `xml:id="study-conclusions-5-4"` so it misses the green CSS styling.

### `source/ch5/inv-5-5.ptx`
- Summary table drops every £ symbol (PDF: £24.13 etc.) and the "n = 393" total cell is missing.
- **(c) main instruction missing:** PDF "Calculate the F-statistic (by hand) and then use technology to determine the p-value (sketch and shade the corresponding randomization distribution)" → PTX only "Confirm your calculations using technology."
- **Tech-detour hints expose answers not in the PDF:** R hint adds "with x = 29.2, df1 = 2, and df2 = 390"; JMP hint adds "for F = 29.2…"; a fourth hint titled "Solution" gives "F = 226/7.73 = 29.2. The p-value is approximately zero." Also R/JMP output images shown in the student-visible statement. (Internal inconsistency too: hints say F = 29.2; Study Conclusions correctly says 31.48 per the PDF.)
- JMP navigation dropped ("Input quantiles…, X > Qa").
- Practice 5.5B: the PDF's "pooled t-test" glossary hyperlink is missing.

### `source/ch5/inv-5-5-applet.ptx`
- (j): missing parenthetical "(Drag the slider to decrease the value in increments of 0.1, or edit the orange value, watching how the p-value changes.)"
- Discussion missing its lead-in sentence ("However, when there truly is a difference in the population means, our ability to detect that difference… is affected by several factors:"); the three bullets survive as run-together prose.

### `source/ch5/inv-5-6.ptx`
- **Study Conclusions heavily condensed/paraphrased** (the known inv-5-6 offender pattern): the PDF's two full paragraphs (directional parentheticals, the "pervasive effect" explanation, and the transition sentence "First, we will examine a numerical measure of the strength of the association…") compressed to two short sentences. Should be restored verbatim. (Data table: all 18 rows verified verbatim.)

### `source/ch5/inv-5-7.ptx`
- **Sign/order error introduced:** PDF "It will obtain the value of −1 or 1 if the points fall along a perfect line (with negative or positive slope, respectively)." → PTX reverses to "1 or −1" while keeping "negative or positive, respectively" — the statement is now incorrect (pairs r = 1 with negative slope).

### `source/ch5/inv-5-8.ptx`, `applet-5-7-correlation-guessing.ptx`, `applet-5-8-regression-behavior.ptx`, `excel-5-8-minimization.ptx`, `inv-5-9.ptx`, `section5-3-summary.ptx`
- No material issues — verbatim (inv-5-8 uses "SSError" where the PDF says "SSE", cosmetic; all coordinates/values verified).

### `source/ch5/inv-5-10.ptx`
- **LLM-invented transition paragraph** between the Study Conclusions box and the Discussion ("The above simulation approach is a very intuitive way… a more formal approach…"). The PDF goes directly from Study Conclusions to Discussion. Remove or author-approve.
- (g): autograded `<var>` fill-ins whose `<setup>` embeds the numeric answers (32.364, 8.581, 38.51, 16.85, 8.265) with feedback — graded-answer content not in the student PDF (plausibly from the instructor key; author's call).
- (Everything else verified question-by-question incl. formulas rendered visually — verbatim.)

### `source/ch5/inv-5-11.ptx`
- Material: none. (Two invented one-line question stubs — see Drift.)

### `source/ch5/inv-5-12.ptx`, `inv-5-13.ptx`, `inv-5-14.ptx`, `summary-5-4-inference-regression.ptx`, `tech-5-4-regression-effect.ptx`, `section5-4-summary.ptx`, `ch-5-4.ptx`, `ch-5-1.ptx`, `ch-5-2.ptx`, `ch-5-3.ptx`, `section5-1-summary.ptx`, `section5-2-summary.ptx`
- No material issues — verbatim (incl. PDF typos faithfully preserved; URLs match link annotations; xref numbering checked).

### `source/ch5/eoc-example-5-1.ptx` … `eoc-example-5-4.ptx`
- 5-2/5-3/5-4: added intro line "Try these questions yourself…" that the PDF prints only on Example 5.1 (likely intentional harmonization).
- **Minitab named in PDF-verbatim analysis text** (5-3: "computed by Minitab…"; 5-4: "Minitab produces the following ANOVA table/output" ×3). Faithful to the source, but flagged per the no-Minitab policy — the *source itself* still says Minitab here; author may want to reword.
- All numbers verified against the PDF (incl. the source's own internal inconsistencies, preserved verbatim). URLs match link annotations.

### `source/ch5/chapter-5-summary.ptx`
- The PDF's Index (pp422–423) has no counterpart in this file — presumably handled by PreTeXt backmatter/auto-index; confirm the book has an index somewhere.
- Summary prose, procedure-choice table (verified visually), and R/JMP quick-reference tables all present and verbatim.

---

# Section 2 — Wording drift / paraphrase (not material)

## Preliminaries

### `source/frontmatter.ptx`
- PDF p4 (Tukey quote): "play in everyone **else's** backyard" → PTX: "play in everyone's backyard" (word dropped from a direct quotation).

### `source/inv-a.ptx`
- PDF p5: "Here is a snippet from data table from NOAA" → PTX: "Snippet from NOAA data table showing storm classifications" (+ added source-link line).
- PDF p7 (f): "Conjecture: The mean is actually 7.2 hurricanes for this dataset…" → PTX: "Conjecture: The mean of these 31 observations is 7.2 hurricanes. Do you think 7.2 is larger or smaller…"

### `source/inv-b.ptx`
- PDF p11: "Open the Random Babies applet and press Randomize. Notice that…" → PTX: "Now let's use technology to simulate this process many more times… follow these steps:" + added bullet "Run the applet for at least 1000 trials total."
- PDF p11 (i): "Describe what you learn about how the (cumulative) proportion of trials that result in zero matches changes…" → PTX: "Look at the time plot in the applet that shows the running proportion of trials with 0 matches. What do you notice…"
- PDF p13 (n): "How many different outcomes are there for returning four babies to their mothers?…" → PTX: "How many possible outcomes are there in the sample space?… probability of any one specific outcome (e.g., 1234)?"
- PDF p14 (s): "How do these theoretical probabilities compare to the empirical estimates you found in the simulation (question (j))?" → PTX: "How do your exact probabilities compare to the empirical estimates you obtained from the simulation?"
- PDF p16: typo corrections ("determine how the probability" → "determine the probability"; "the balls lands" → "the ball lands").

### `source/inv-c.ptx`
- PDF p17: "Visit https://scied.ucar.edu/interactive/make-hurricane" → PTX: "Visit the **UCR** Science Education Make a Hurricane site" ("UCR" presumably a typo for UCAR).
- PDF p18 (e) hint: adds "How are you deciding? Are you using the data or something beyond the data?"
- PDF p19 Practice C.B: "more likely" → "more believable"; "are all 'bell-shaped and symmetric'" → "are all **roughly** 'bell-shaped and symmetric'".

## Chapter 1

### `source/ch-1-intro.ptx`
- "Factors affecting p-value" → "Factors impacting p-values".

### `source/ch1/inv-1-1.ptx`
- PDF p21: "In this investigation you will be introduced…" → PTX: "In this first investigation…" (also relocated).
- PDF p22 (f): drops "(Optional: See Technology Detour.)", appends "What is your title?"
- PDF p21 typo silently corrected: "laying for the foundation" → "laying the foundation".

### `source/ch1/inv-1-2.ptx`
- Detour heading "Probability Detour – Binomial Random Variables" → "Definition: Binomial Random Variable" (Probability Detour title commented out; chapter contents still advertise the detour).
- R detour output sentence condensed (Graphics-window/toggle wording → "You should see both the probability… and a shaded binomial distribution graph").
- "(Optional: See Technology Detour below.)" → "…at the end of this investigation for R/JMP instructions."
- PP1.2B(d): "the technology instructions below" → "the software".

### `source/ch1/inv-1-3.ptx`
- (a) applet instructions reworded/condensed (URL sentence → "Take the Sense the unknown test type…").
- "(See Exploration B…)" → "(See Investigation B…)".
- (m): "Use the applet to explore" → "Return to the applet and explore".
- PP1.3C: "the proportion who prefer Coke" → "the proportion of all students at your school who prefer Coke"; PP1.3B: "Return to the wolf (Yukon)." → "Return to the Investigation 1.2 wolf (Yukon)."

### `source/ch1/inv-1-4.ptx`
- Detour retitled "Binomial Test of Significance" → "Calculating Binomial Probabilities".
- R example rewritten around the infant study instead of Friend-or-Foe (introduces "study study" typo).
- PP1.4C(b): "black" → "African American" (intentional per commit ff94b19).

### `source/ch1/inv-1-5.ptx`
- (m): applet-verification instruction and hint rewritten ("Start with 3 and use the 'Tails' option…").
- R hint adds an "The output will show:" bullet list not in the PDF.

### `source/ch1/inv-1-6.ptx`
- Study Conclusions: "for a binomial process probability" → "for a binomial process" ("probability" dropped).
- (i): reworded to name the applet and 99% interval explicitly; compare-question split out.

### `source/ch1/inv-1-7.ptx`
- (a): "Prediction:" → "Conjecture:".
- "sort them" → "sort them by color"; "Open the… applet" → "Using the… applet"; "you predict that" → "you found that".
- (l): "Repeat (i) and (j)" → "Repeat the previous questions (using the formulas, checking against the applet)" (gloss describes the wrong parts).
- PP1.7A: question restructured to fill-in blanks (same meaning).

### `source/ch1/inv-1-8.ptx`
- Study Conclusions parentheticals reordered/merged (same meaning).
- (p): "Which p-value in (h)" → "Which p-value from the earlier comparison".
- R detour: "observed = the observation of interest" → adds "(count or proportion)".
- (m) hint: trailing duplicate "see Technology Detour below" dropped.

### `source/ch1/inv-1-9.ptx`
- (j)/(k): "Explain." dropped in MC conversion.
- (c) and (l) split into multiple exercises (content preserved).
- PP1.9B(c): rephrased into six Valid/Invalid MC items; "chased" → "chases".

### `source/ch1/inv-1-10.ptx`
- Plus-Four definition: explicit 1.96 multiplier → z\*.
- (p): "How do the… intervals compare (compare the centers and widths)?" → "Compare: ___" + "Round to 3 decimal places."
- (c): adds "Does the technology output match your calculation…?" (MC conversion).

### `source/ch1/summary-1-10.ptx`
- "these methods plus a fifth, the 'Score interval'" → "plus **a another**, the 'Score interval'" (grammar error introduced).

### `source/ch1/inv-1-11.ptx`
- (a): "in symbols and in words" → "by specifying correct symbols and values" ("in words" dropped).
- (g): adds "use the applet to"; (h): adds "(increases, decreases, no change)" scaffolding.
- PDF typo corrected: "Bern and Honorton" → "Bem and Honorton".

### `source/ch1/inv-1-12.ptx` / `activity-1-12-data.ptx`
- (h) dotplot instruction adapted to the class-dotplot applet; "Label:" prompt dropped.
- "just 10 of the words" → "just 10 of the 268 words in the Gettysburg Address".
- (a): "Circle 10 representative words… Consider the sample you selected in (a)." → "Paste your 10 words from the data collection activity below…" + added tip.
- PDF typos corrected ("observational units" → "unit"; "when we using" → "when using").

### `source/ch1/inv-1-13.ptx`
- (f): "How does the mean and standard deviation compare to (c)?" → expanded "Report… and comment on how they compare to Question 4."
- PP1.13B(a): declarative "the coverage rate is not too different from the desired 95%." → question "is the coverage rate close to the desired 95%?"

### `source/ch1/inv-1-14.ptx`
- Intro: "taken on a sample from" → "taken on a sample selected from".
- (a) split into three exercises + added symbol MC with distractors; (b): "(in symbols and in words)" → quoted headline.
- Practice 1.14: added exercise statement "Test the hypotheses using a z-test… state your conclusion in context."

### `source/ch1/summary-1-14.ptx`
- Title drops "Proportion of"; "≥" → ">" in technical conditions (numerically inconsequential).

### `source/ch1/inv-1-15.ptx`
- (d): "likely to be representative" → "reasonable to consider this sample as representative"; added "(rounded to 3 decimal places)".
- Technology Detour merged with question (g) (detour wording itself verbatim).

### `source/ch1/inv-1-16.ptx`
- Post-stratification table label "Ratio (actual/claimed)" → "Ratio" (+ added "1932 Vote" header).
- "e.g., respondents accurately reported…" parenthesization subtly changes sentence structure.
- (d) hint: adds example formula "=C52/AA52".

### `source/ch1/inv-1-17.ptx`
- (None — verbatim.)

### `source/ch1/section-wrap-up.ptx` (Examples 1.1–1.3)
- All three examples: "Try these questions yourself before you use the solutions following to check your answers." → "…before viewing the solutions."
- Procedures table: "Exact p-value" → "Exact distribution"; "Can use z procedures if" → "Valid when (for z procedures)"; "At least 10 successes and 10 failures **in each group**" loses "in each group"; CI row condensed ("all plausible values with two-sided p-value > 0.05"); "One proportion" → "One proportion scenario".

## Chapter 2

### `source/ch2/inv-2-1.ptx`
- (h) hint: R hints merged/expanded with the `births2` edit example and "(i.e., OEG == 2)" moved into the hint.
- (m): normal-overlay instruction split between detour and exercise; R call changed (`iscamaddnorm(births3$birthweight, main, xlab, bins)` → `hist(...); iscamaddnorm(...)`).
- (n) JMP: example limit values (2415/4258) removed.
- (q): "Include a well-labeled sketch…" → "(Be sure to make sure your answer is consistent with a well-labeled sketch…!)".
- JMP dotplot "X label" → "X axis"; Practice 2.1A "Create and include" → "Create".
- (j) split into determine/interpret exercises.

### `source/ch2/inv-2-2.ptx`
- Heading "Modelling non-normal data" dropped (paragraph kept unheaded).
- (e): "Create by hand a boxplot" → "Create a boxplot… by hand".
- (d) interpretation prompt moved into the response box.

### `source/ch2/inv-2-3.ptx`
- Added method-revealing hints on (c)/(d) (middle-value counting; average of 15th/16th).
- (e): MC whose correct option states the answer.

### `source/ch2/inv-2-4.ptx`
- Applet setup: paste-from-clipboard workflow → type-filename workflow.
- 159.574 → 159.6 in two places.
- (j): adds "Scroll to the far right and".
- Gettysburg reference rendered as an xref (equivalent).

### `source/ch2/inv-2-5.ptx`
- (i) hint condensed/reworded; question became yes/no MC.
- (u) merged into (t) with "of 1.96" added.
- R detour `conf.level = 95` → `0.95`; base-R t.test example expanded with placeholder vector.

### `source/ch2/inv-2-6.ptx`
- PP2.6A (a)/(b): CI/PI formulas inserted inline where the PDF states none.
- (f): "Calculate this value" → "Calculate s√(1+1/n)".
- (b): appends "(report to two decimal places)".
- Practice 2.6B: added jamanetwork.com URL.

### `source/ch2/inv-2-7.ptx`
- (a): "Identify the observations." → "What are the observational units?"
- (f): first half moved out of the exercise into body text (no longer an answerable prompt).
- Practice 2.7: added statement "Carry out the sign test for the 30 seconds data." (names the method the PDF leaves to the student).

### `source/ch2/inv-2-8.ptx`
- (c): "in (b)" → "of the logged data values"; (f): adds "Use your calculator to"; xref made more specific ("Investigation 2.2, Question 9").

### `source/ch2/inv-2-9.ptx`
- (h): repeat-instruction moved to body; statement replaced by added "Interpret your results."
- Applet bullet loses "In applet," context word.

### `source/ch2/sec-2-summary.ptx`
- TBI hint drops "(< > for not equal)"; "the button" → "the > button".
- R row: "t.test (data, hypoth, alt=…)" → "t.test(data, mu = hypothesized, alt = …)".

### `source/ch2/section-wrap-up.ptx`
- Example intros: "…before you use the solutions following to check your answers." → "…before viewing the solutions."
- "What You Have Learned": PDF's nested sub-bullets flattened to a single-level list.
- R quick-reference: "μ" → "mu" argument normalization.

## Chapter 3 (part 1)

### `source/ch-3-intro.ptx`
- "Chapter 3 Summary" heading restructured as "Chapter 3 Wrap-Up" grouping; "conditional props" → "conditional proportions".

### `source/ch3/inv-3-1.ptx`
- "two groups" → "two samples"; "independent random samples" (added "independent"); (j) adds "(assuming the null hypothesis is true)"; defining fraction (480+333)/(2928+1771) dropped; "1,000 independent random samples" → "1,000 independent pairs of random samples"; (r) options SIMILAR/LARGER/SMALLER → Equal/Larger/Smaller; (s) adds "(formula)"; (x) adds parentheticals; (z) adds "(by hand)"; "Confidence Interval" heading → "Case 2" title.

### `source/ch3/inv-3-2.ptx`
- Intro paragraphs reordered; (b): "what this graph reveals" → "what your numbers and graph reveals"; "two different random samples" → "two distinct random samples"; PDF's "(d)" typo silently corrected to Question 5; Study Conclusions: "did not 'luck of the draw' alone" (PDF missing words) → "did not arise from 'luck of the draw' alone".

### `source/ch3/inv-3-3.ptx`
- Definition: "(often called treatment)" → "(the categories are often called treatments)"; (m)/(n): "Explain." dropped in Yes/No MC conversion; introduced duplicated word "roughly roughly" in inv3-3-i; conclusions table rendered as image.

### `source/ch3/inv-3-4.ptx`
- Trivial: added "(click on image to enlarge)" caption.

### `source/ch3/inv-3-5.ptx`
- "Quick Check:" → "For Practice"; second question reworded ("proportion of subjects who were given dolphin therapy and improved" → "proportion of all subjects were given dolphin therapy and improved"); (c) expanded into three fill-in prompts; "A recent study" → "A 2010 study"; added applet-embedding bullet.

### `source/ch3/inv-3-6.ptx`
- PDF's "Investigations 3.6 (Dolphin Therapy)" numbering typo silently corrected to 3.5; JMP detour adds "(minus 1)" and "upper" (consistent with PDF's Keep-in-Mind note but not verbatim); "two-table table" typo corrected.

## Chapter 3 (part 2)

### `source/ch3/inv-3-7.ptx`
- (d): "Use technology" → "Use R or JMP"; "Section 3.1" → "Investigation 3.1". Everything else verbatim (all table values verified).

### `source/ch3/inv-3-8.ptx`
- Relative-risk definition re-expressed symbolically (p̂₁/p̂₂ with larger/smaller note) — same meaning.
- "[See the Technology Detour below…]" → "[Optional: See the Technology Detour at the end of Ch. 3… with R or JMP.]" (also introduces typo "conduting").
- (m): parenthetical "(near in the middle or in the tail)" dropped; Note appends "…than using the SD from the null distribution"; (v) instruction moved to a bullet with invented "How do the intervals compare?" statement; (e) adds a fill-in scaffold sentence.

### `source/ch3/inv-3-9.ptx`
- "So we could use either (e) or (f) as the statistic" → "either Odds Ratio as the statistic" (also relocated); "in group B" → "'success'"; "Doing so for the second case:" → "…yields the following distribution:"; (a) appends "Explain."

### `source/ch3/inv-3-10.ptx`
- (c): "Calculate and interpret this statistic." → "Calculate this statistic." (interpret dropped); PDF "Though cluster sampling" typo corrected to "Through".

### `source/ch3/summary-r-commands.ptx` / `summary-jmp-commands.ptx`
- "below some number x (creating an empirical p-value)" → "below x" (parenthetical dropped in both); PDF R typos silently corrected (`fisher.text` → `fisher.test`; malformed matrix syntax fixed).

## Chapter 4

### `source/ch-4-intro.ptx`
- PDF typo "Comparing for two treatment means" silently fixed; "Examples" heading added to the listing (layout only).

### `source/ch-sec-4-1.ptx`
- "In this chapter, we will focus…" → "In this section…"; PDF's "SECTION 1: COMPARING GROUPS – QUANTITATIVE REPONSE [sic]" retitled "Section 4.1: Comparing Two Groups with a Quantitative Response".

### `source/ch4/inv-4-2.ptx`
- TBIA detour steps reworded ("Use the pull-down menu to select 'Two means.'" → "Select 'Two Means' from the Scenario pull-down menu…", plus added/dropped bullets); R examples: `with()` wrapper and attach-note dropped, summary example swapped from generic numbers to elephant data; JMP steps reworded ("Use the hot spot" → "Click on the red triangle next to Oneway Analysis"); added "(You may have to scroll right in ther applet.)" (typo "ther"); "Enter elephants.txt" → "Type elephants.txt"; added convenience deep-link.

### `source/ch4/inv-4-8.ptx`
- Added `<alert>` headings not in the PDF ("Ask a Research Question", "Discussion", "Alternative study design"); PDF's "typing seed" typo corrected; Practice 4.8B (a)–(e) converted to MC (no feedback text on choices).

### `source/ch4/inv-4-9.ptx`
- (d)/(m) open questions converted to MC/split exercises (wording verbatim); PDF's "reducing the among of" typo corrected to "amount"; "Repeat (a)" → "Repeat the previous question".

### `source/ch4/inv-4-10.ptx`
- (c) converted to MC (Independent samples / Paired design); statement verbatim.

### `source/ch4/example-4-1.ptx` … `example-4-4.ptx`
- 4-1 (b): adds "(in years)" + numeric fill-in; 4-2 (e): "in (d)" → "in the previous question"; 4-4: invented one-line exercise statement ("Address the questions posed in the introduction…") to hang the response box on; asides with applet links added.

### `source/ch4/summary-chapter.ptx`
- "a genuine difference in the groups" → "in the treatments/populations"; "The advantage of" → "The main advantage of" (+ appended "for these other statistics"); bullet-hierarchy restructured; procedures table: column header drops "random", "population medians equal" symbolized to μ̃₁ − μ̃₂ = 0, "flip" → "interchange", PDF's merged exact-p-value cell split into three (adding "All possible sign assignments" text not in the PDF), R args "mean1, stddev1…" → "xbar1, s1…".

## Chapter 5

### `source/ch-5-intro.ptx` / `ch-5-1.ptx`
- "In the previous chapters, you have been limited to exploring two groups at a time" → "…only one or two groups…"; "expand on your earlier techniques" → "expand those techniques".

### `source/ch5/inv-5-1.ptx`
- Heading "Standardized (Test) Statistic" → "Choose a Statistic"; **(c) drops "standardized"** ("Suggest a standardized statistic…"); Definition-box and chi-squared-explanation sentences lightly reworded; chi-squared-model box, applet detour, and Technical Conditions all paraphrased (see Material for the bigger issues).

### `source/ch5/inv-5-1a.ptx`
- Intro sentences reworded ("this has led to speculation…" → "This has raised concerns…"); expected-count definition re-expressed around the formula; df statement reworded ("The degrees of freedom… is df = (r−1)(c−1)" → "This statistic often follows a chi-squared distribution with degrees of freedom (r-1)(c-1)"); collapse-table lead-in reworded.

### `source/ch5/inv-5-2.ptx`
- Intro sentence reworded; chi-squared-conditions box paraphrased; table headers shortened ("Tortoise and Hare (control)" → "Tortoise (control)", "Boy Who Cried Wolf" → "Wolf"); Practice (b) drops "for this chi-squared statistic".

### `source/ch5/inv-5-3.ptx`
- Intro reworded/condensed; (a) drops "that would be" ("Outline a simulation appropriate…").

### `source/ch5/chi-square-test-summary.ptx`
- Association/homogeneity condition lines lightly reworded; added hint-reveal lead-in sentence.

### `source/ch5/inv-5-4.ptx`
- Extensive light rewording throughout the intro and questions (j), (k), (o), (q), (t), (x), (y), the Probability Result, R detour, and Terminology Detour (see agent list; each keeps meaning but is not verbatim); table headers abbreviated ("None / Ampu / Crut / Hear / Wheel"); "assigned by" → "across all".

### `source/ch5/inv-5-5.ptx` / `inv-5-5-applet.ptx`
- F-Calculator applet bullet condensed (drops "Specify the degrees of freedom" and "direction for the probability of interest"); Discussion drops "for example" and "in essence… that we could be making".

### `source/ch5/inv-5-6.ptx`
- (c)/(e): "(b)"/"(d)" part-references replaced by paraphrases ("your analysis of takeoff velocity", "your earlier expectation") instead of cross-refs.

### `source/ch5/inv-5-10.ptx` / `inv-5-11.ptx` / `inv-5-14.ptx`
- 5-10 (f): "time" → "finish time"; SD(b₁) formula algebraically identical but rendered differently (σ inside the radical); "found here" → "found online". 5-11 (a)/(e): invented one-line question stubs ("Report the regression equation." / "Report your estimated p-value.") added to hang response boxes on applet-action bullets. 5-14 (a): "housing file" → "housing.txt file"; r² → R².

### `source/ch5/excel-5-8-minimization.ptx` / `applet-5-8-regression-behavior.ptx`
- Excel (c): "Reproduce a rough sketch of this graph below, and comment…" → "Comment…" (sketch clause dropped — not feasible online); (g): "note how" → "Describe how". Applet page intro reordered with "The data have been preloaded into the applet." added.

### `source/ch5/eoc-example-5-4.ptx` / `chapter-5-summary.ptx`
- 5-4: instruction paragraph moved ahead of the question list, "given below" added. Summary: χ² formula variables abbreviated to O/E; three per-column "Analyze > Fit Y by X" cells collapsed into one with "(for all three procedures)" added; two PDF R-table typos silently corrected (missing paren; "resonse").

---

*End of report. Also noted during the pass: `source/iscam4_RJMPFall26.pdf` is newer than the `Win26` PDF that CLAUDE.md names as gold source — CLAUDE.md should be updated to point at Fall26 (not done in this pass, which was report-only).*
