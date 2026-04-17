<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu|brunopacheco1@yahoo.com)

SPDX-License-Identifier: CC-BY-4.0
-->

[![REUSE status](https://api.reuse.software/badge/github.com/brunopacheco1/ma-quetelye-quenya)](https://api.reuse.software/info/github.com/brunopacheco1/ma-quetelye-quenya)
![test workflow](https://github.com/brunopacheco1/ma-quetelye-quenya/actions/workflows/test.yml/badge.svg)
![publish workflow](https://github.com/brunopacheco1/ma-quetelye-quenya/actions/workflows/publish.yml/badge.svg)
[![GitHub contributors](https://img.shields.io/github/contributors/brunopacheco1/ma-quetelye-quenya)](https://github.com/brunopacheco1/ma-quetelye-quenya/graphs/contributors)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

# Ma Quetelyë Quenya?

An open-source, multi-language textbook designed to teach the Quenya language (the High-Elven tongue of J.R.R. Tolkien). This project adopts the pedagogical structure of "Schwatzt Dir Letzebuerg?" to provide a clear, modern, and accessible path to language proficiency.

## Project Overview

This book is written "as code" to ensure it remains open, maintainable, and easily translatable. We aim to bridge the gap between academic linguistic studies and practical language learning.

### Tech Stack
- **[Quarto](https://quarto.org/):** A scientific and technical publishing system built on Pandoc.

## Getting Started

### Prerequisites
To build this book locally, you will need:
1. [Quarto](https://quarto.org/docs/get-started/) installed on your machine.

### Building the Book
1. Clone the repository:
   ```bash
   git clone https://github.com/brunopacheco1/ma-quetelye-quenya.git
   cd ma-quetelye-quenya
   ```

### Previewing Locally
To actively edit and preview the book, Quarto provides a live-reloading server:
```bash
# Preview the default English version
quarto preview

# Preview the Portuguese version
quarto preview --profile pt
```

### Rendering
To generate the final static files (HTML, PDF, EPUB) without starting a server:
```bash
# Render the default English version
quarto render

# Render the Portuguese version
quarto render --profile pt
```

## License

This project complies with the [REUSE specification](https://reuse.software/). Because a textbook contains different types of media, multiple licenses are used depending on the content:

- **Text and Educational Content:** Licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSES/CC-BY-4.0.txt).
- **Code and Configuration:** Workflows, automation scripts, and project configurations are licensed under the [Apache License 2.0](LICENSES/Apache-2.0.txt).
- **Fonts:** Included custom fonts are licensed under the [SIL Open Font License 1.1 (OFL-1.1)](LICENSES/OFL-1.1.txt).

You can find the exact license pertaining to any specific file by checking its SPDX header or its accompanying `.license` file.
