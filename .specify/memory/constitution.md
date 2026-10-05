<!--
Sync Impact Report
Version change: template → 1.0.0
Added principles: I–VII (initial ratification)
Templates requiring updates: none (plan/spec/tasks templates reference the constitution generically)
Follow-up TODOs: none
-->

# Ma Quetelyë Quenya? Constitution

## Core Principles

### I. Quenya-Only Chapters

Chapters (`docs/carince_*.qmd`) contain no language besides Quenya and are shared
by every language profile. Other languages appear only in the per-language
introductions (`docs/<lang>/intro.qmd`), tables of contents (`docs/<lang>/toc.qmd`)
and neologism notes (`docs/<lang>/neologisms.qmd`). Image alt text is the one
exception: it MUST be readable by a screen-reader user, so it is not Quenya-only.

### II. Eldamo Is the Source of Truth

Every Quenya word, form and gloss MUST be checked against
[Eldamo](https://eldamo.org/). Where Eldamo marks a word as a neologism or
reconstruction, the book says so. New coinages go in the neologism notes with
their formation and Eldamo links. Other linguistic interpretations cite their
source (e.g. *Parma Eldalamberon*, *The History of Middle-earth*).

### III. Languages in Parallel

All language editions (currently EN and PT) are maintained in parallel. A change
to a per-language file in one language MUST be made, or explicitly flagged as
pending, in every other language in the same change.

### IV. Pedagogy First

The book follows the structure of *Schwatzt Dir Letzebuerg?*: short, practical,
communicative lessons that build step by step, favouring real-life scenarios and
pictures over grammar tables.

### V. Open and REUSE-Compliant

Every file carries a REUSE license header, a `.license` sidecar, or a
`REUSE.toml` annotation. Code (scripts, workflows, configuration, build and site
tooling) is Apache-2.0. Creative content (lessons, texts, exercises, images,
translations, specs) is CC-BY-4.0. Third-party assets keep their own license
(fonts OFL-1.1, Spec Kit scaffolding MIT). `reuse lint` MUST pass.

### VI. Accessible Output

`quarto render` MUST pass for every profile and format (HTML, PDF, EPUB) before a
PR is opened. Rendered pages are checked at 200% zoom and for screen-reader
accessibility (alt text, labelled controls, heading order).

### VII. Clean Repository

Generated and cache folders (`_book/`, `_site/`, `.quarto/`,
`.specify/extensions/.cache/`) are never committed.

## Workflow

- Features follow the Spec Kit flow: `/speckit-specify`, `/speckit-plan`,
  `/speckit-tasks`, `/speckit-implement`, then `/speckit-converge`. Specs live
  under `specs/`.
- Commits use semantic prefixes (`feat:`, `fix:`, `chore:`, …) because the
  changelog is generated from them.
- Every PR gets a rendered preview; reviewers check it before merging.

## Governance

This constitution supersedes other practices in this repository. Amendments are
made by PR, bump the version (MAJOR for removed or redefined principles, MINOR
for new principles or sections, PATCH for wording) and update the Sync Impact
Report. The maintainer (Bruno Pacheco) approves every PR approval and merge.

**Version**: 1.0.0 | **Ratified**: 2026-10-05 | **Last Amended**: 2026-10-05
