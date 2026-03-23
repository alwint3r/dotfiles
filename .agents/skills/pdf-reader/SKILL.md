---
name: pdf-reader
description: Read PDFs by rendering pages to per-page PNG images with pdftoppm, then inspect the rendered pages visually before answering. Use this for page-specific reading, ranged-reading, scanned PDFs, slide decks, tables, diagram, and other layout-sensitive documents.
---
# PDF Reading Skill for Agentic AIs (using `pdftoppm`)

## Purpose

Use this skill when you need to read, inspect, review, or extract information from a PDF by first rasterizing pages into PNG images with `pdftoppm`. This workflow is reliable for page-by-page visual inspection, region-aware reading, scanned PDFs, mixed-layout documents, and verifying what a human would actually see.

This skill is for **reading/review**, not primary editing.

---

## Why `pdftoppm`

`pdftoppm` is a strong default for PDF reading because it:

* renders each page deterministically into an image,
* supports page selection and page ranges,
* works well in shell pipelines,
* avoids ambiguity from raw text extraction when layout matters,
* is useful for both born-digital and scanned PDFs.

Use it when the page appearance, figure placement, tables, callouts, annotations, and visual grouping matter.

---

## Core rule

For PDF reading tasks, prefer this workflow:

1. Render selected pages to PNG with `pdftoppm`
2. Inspect images page by page
3. Optionally combine with text extraction only after visual inspection
4. Cite page numbers explicitly in the final answer

Do **not** rely only on raw text extraction when any of the following matter:

* tables
* diagrams
* multi-column layout
* forms
* scanned pages
* footnotes
* captions
* highlighted or boxed content

---

## Primary commands

### Render all pages

```bash
pdftoppm -png input.pdf /tmp/pdf_pages/page
```

Produces files like:

* `/tmp/pdf_pages/page-1.png`
* `/tmp/pdf_pages/page-2.png`
* ...

### Render a single page

```bash
pdftoppm -png -f 7 -l 7 input.pdf /tmp/pdf_pages/page
```

### Render a page range

```bash
pdftoppm -png -f 10 -l 15 input.pdf /tmp/pdf_pages/page
```

### Higher resolution for small text / dense diagrams

```bash
pdftoppm -png -r 300 input.pdf /tmp/pdf_pages/page
```

### Crop box instead of media box when needed

```bash
pdftoppm -png -cropbox input.pdf /tmp/pdf_pages/page
```

---

## Resolution policy

Use this default DPI policy:

* **150 DPI**: quick skim, rough structure check
* **200 DPI**: normal reading
* **300 DPI**: small text, tables, dense technical docs, scanned PDFs
* **400+ DPI**: only when a page still cannot be read clearly

Do not start too high unless necessary; it wastes time and disk.

---

## Directory convention

Use a predictable workspace:

```text
/tmp/pdf_job/
  input.pdf
  renders/
    page-1.png
    page-2.png
  notes.txt
  extracted/
```

This keeps the workflow reproducible and easy for agents to reason about.

---

## Operating procedure

### Mode A: quick review

Use when the user wants a summary, sanity check, or a fast answer.

1. Render pages at 150–200 DPI
2. Inspect all pages or requested range
3. Note title, section boundaries, tables, diagrams, warnings, conclusions
4. Return a concise summary with page references

### Mode B: careful reading

Use when the user wants accuracy, detailed extraction, or technical interpretation.

1. Render pages at 200–300 DPI
2. Read each requested page fully
3. Track section titles and page numbers
4. Extract structured notes:

   * page number
   * heading
   * key claims
   * numbers/units
   * assumptions
   * warnings/exceptions
5. Only after visual reading, optionally confirm with text extraction tools

### Mode C: scanned PDF handling

Use when pages look like photographs or scans.

1. Render at 300 DPI
2. Inspect whether text is readable visually
3. If needed, hand off to OCR after confirming the pages are image-based
4. Use OCR as a fallback, not the first step

---

## Decision rules

### Read visually first when:

* the PDF contains figures or screenshots,
* the PDF is a slide deck,
* the PDF uses multiple columns,
* the user asks about a specific table/chart,
* the PDF may be scanned,
* the exact visual placement matters.

### Use text extraction only as a supplement when:

* the document is clearly text-first,
* you need copyable text,
* you need searchability across many pages,
* you need to quote or structure passages after confirming page context.

### Escalate DPI when:

* table cells are unreadable,
* subscripts/superscripts disappear,
* code snippets blur,
* scanned text is noisy.

---

## Page-selection strategy

If the user asks for:

### “Read the whole PDF”

* Render all pages
* Skim all pages first
* Then re-read high-value pages in detail

### “Read page X”

* Render only page X
* If context is needed, also render X-1 and X+1 when available

### “Read pages A–B”

* Render exactly that range
* Preserve page numbers in notes

### “Find where topic T is discussed”

* If a text layer exists, search text first
* Then render only likely matching pages plus neighbors
* Verify visually before answering

---

## Output format for agent notes

Use this internal note format:

```text
Page 12
Heading: System Architecture
Type: diagram + bullets
Key points:
- Sensor MCU sends packets over UART to host board.
- Retry logic is host-driven, not MCU-driven.
- Timing budget shown as 20 ms acquisition + 5 ms processing.
Open questions:
- Diagram implies DMA, but caption does not confirm it.
```

For tables:

```text
Page 18
Heading: Power Budget Table
Columns: mode | current | voltage | notes
Rows captured:
- idle | 35 mA | 3.3 V | Wi-Fi off
- active TX | 240 mA | 3.3 V | burst peak
Warnings:
- Peak vs average current not clearly separated.
```

---

## Final answer policy

When answering the user:

* always mention the relevant page number(s),
* separate direct observations from inference,
* state uncertainty when a page is blurry, occluded, or ambiguous,
* do not claim text that was not actually visible or extractable.

Good pattern:

```text
On page 7, the block diagram shows three stages: acquisition, filtering, and transmission. The caption suggests the filtering runs on-device, but the page does not explicitly state whether it uses DMA.
```

---

## Failure modes and fixes

### 1. Text too small

Fix:

* rerender at 300 DPI
* if still bad, 400 DPI only for the affected pages

### 2. Wrong page bounds / too much whitespace

Fix:

```bash
pdftoppm -png -cropbox input.pdf /tmp/pdf_pages/page
```

### 3. Page numbering confusion

Fix:

* remember `pdftoppm` output numbering is 1-based by page sequence
* verify against the PDF’s printed page labels when needed

### 4. Huge PDFs

Fix:

* render only a target range first
* do a skim pass before a full pass

### 5. Scanned PDF is unreadable

Fix:

* increase DPI
* consider grayscale or OCR in a later step
* be explicit about reduced confidence

---

## Practical shell snippets

### Render pages 20–25 at 300 DPI

```bash
mkdir -p /tmp/pdf_pages
pdftoppm -png -r 300 -f 20 -l 25 input.pdf /tmp/pdf_pages/page
```

### List generated files in order

```bash
ls -1 /tmp/pdf_pages/page-*.png | sort -V
```

### Count pages rendered

```bash
find /tmp/pdf_pages -name 'page-*.png' | wc -l
```

---

## Recommended behavior for agentic AIs

1. Prefer the smallest page range that answers the task.
2. Read visually before making claims.
3. Re-render only problematic pages at higher DPI instead of the whole document.
4. Keep structured page notes.
5. Distinguish clearly between:

   * visible facts,
   * extracted text,
   * interpretation,
   * uncertainty.
6. For user-facing answers, cite page numbers naturally.
7. Never hallucinate unreadable text.

---

## Minimal reusable skill block

```md
name: pdf-read-pdftoppm
description: Read PDFs by rendering pages to PNG with pdftoppm, then inspect pages visually before answering. Use for page-specific reading, ranged reading, scanned PDFs, slide decks, tables, and layout-sensitive documents.

Instructions:
- Render requested pages with pdftoppm to per-page PNG files.
- Use 200 DPI by default, 300 DPI for dense or scanned pages.
- Prefer visual inspection before any text extraction.
- Preserve page numbers in notes and in the final answer.
- For single-page requests, optionally inspect neighbor pages for context.
- If text is unreadable, rerender only affected pages at higher DPI.
- Separate direct page observations from inference.
- Never claim text that is not legible from the rendered page or validated by extraction.
```

---

## When not to use this skill

Do not use this as the primary workflow when:

* the task is direct text extraction from a clean text PDF at scale,
* the task is PDF editing/merging/splitting rather than reading,
* the task is semantic search over many PDFs and a text layer is already available.

In those cases, use dedicated extraction/indexing/editing workflows instead.

---

## One-line rule

Render first, inspect second, extract third, answer with page numbers.
