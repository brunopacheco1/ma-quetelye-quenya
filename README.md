<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)

SPDX-License-Identifier: CC-BY-4.0
-->

[![REUSE status](https://api.reuse.software/badge/github.com/brunopacheco1/ma-quetilye-quenya)](https://api.reuse.software/info/github.com/brunopacheco1/ma-quetilye-quenya)
![test workflow](https://github.com/brunopacheco1/ma-quetilye-quenya/actions/workflows/test.yml/badge.svg)
![publish workflow](https://github.com/brunopacheco1/ma-quetilye-quenya/actions/workflows/publish.yml/badge.svg)
[![GitHub contributors](https://img.shields.io/github/contributors/brunopacheco1/ma-quetilye-quenya)](https://github.com/brunopacheco1/ma-quetilye-quenya/graphs/contributors)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

# Ma Quetilyë Quenya?

An open-source, multi-language textbook designed to teach the Quenya language (the High-Elven tongue of J.R.R. Tolkien). This project adopts the pedagogical structure of *Schwätzt Dir Lëtzebuergesch?* to provide a clear, modern, and accessible path to language proficiency.

Read it at <https://ma-quetilye-quenya.tolkien.lu/> (the Portuguese edition at [/pt/](https://ma-quetilye-quenya.tolkien.lu/pt/)), or download the PDF and EPUB of each edition from the [releases](https://github.com/brunopacheco1/ma-quetilye-quenya/releases).

## Project Overview

This book is written "as code" to ensure it remains open, maintainable, and easily translatable. We aim to bridge the gap between academic linguistic studies and practical language learning.

### Tech Stack
- **[Quarto](https://quarto.org/):** A scientific and technical publishing system built on Pandoc.

## Help write this book

The book is written by a community of Quenya learners, Tolkien linguists, teachers, artists and developers, coordinated on GitHub. You don't need to be a Quenya expert or a programmer: there are tasks for reviewers, writers, translators, illustrators, voices and developers.

- [CONTRIBUTING.md](CONTRIBUTING.md): the roles, the ground rules, how to pick up a task, how reviews and meetings work.
- [ROADMAP.md](ROADMAP.md): where the book stands and what comes next.
- [STYLE_GUIDE.md](STYLE_GUIDE.md): the choices the book has made, from the setting to the pronunciation standard.
- Issues labelled [`help wanted`](https://github.com/brunopacheco1/ma-quetilye-quenya/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) are ready to take; comment on one to claim it. New here? Open an [I want to help](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/new/choose) issue and the coordinator will find you a task.
- Found a wrong word or a typo? Open a [Quenya error](https://github.com/brunopacheco1/ma-quetilye-quenya/issues/new/choose) issue. That is one of the most useful contributions.

## Getting Started

### Prerequisites
To build this book locally, you will need:
1. [Quarto](https://quarto.org/docs/get-started/) installed on your machine.

### Building the Book
1. Clone the repository:
   ```bash
   git clone https://github.com/brunopacheco1/ma-quetilye-quenya.git
   cd ma-quetilye-quenya
   ```

### Previewing Locally
Each language edition is a Quarto profile named after its `_quarto-<lang>.yml` file. To edit and preview an edition, Quarto provides a live-reloading server:
```bash
# Preview the default edition (English)
quarto preview

# Preview another edition, for example Portuguese
quarto preview --profile pt
```

### Rendering
To generate the final static files (HTML, PDF, EPUB) without starting a server:
```bash
# Render the default edition (English)
quarto render

# Render another edition, for example Portuguese
quarto render --profile pt
```
Before opening a pull request, render every edition (one `quarto render --profile <lang>` per `_quarto-<lang>.yml`) and run `reuse lint`.

## License

This project complies with the [REUSE specification](https://reuse.software/). Because a textbook contains different types of media, multiple licenses are used depending on the content:

- **Text and Educational Content:** Licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSES/CC-BY-4.0.txt).
- **Code and Configuration:** Workflows, automation scripts, and project configurations are licensed under the [Apache License 2.0](LICENSES/Apache-2.0.txt).
- **Fonts:** Included custom fonts are licensed under the [SIL Open Font License 1.1 (OFL-1.1)](LICENSES/OFL-1.1.txt).

You can find the exact license pertaining to any specific file by checking its SPDX header or its accompanying `.license` file.
