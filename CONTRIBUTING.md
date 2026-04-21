<!--
SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu|brunopacheco1@yahoo.com)

SPDX-License-Identifier: CC-BY-4.0
-->

<!-- omit in toc -->

# Contributing to Ma Quetelyë Quenya?

First off, thanks for taking the time to contribute! ❤️

We welcome contributions from linguists, Tolkien enthusiasts, educators, and developers! Whether you are fixing a typo, improving a grammar explanation, or translating the book into a new language, your help is appreciated.

## How to Contribute

### 1. Reporting Issues
Use GitHub Issues to report:
- Errors in Quenya grammar or vocabulary.
- Technical bugs in the Quarto build process.
- Suggestions for new lessons or pedagogical improvements.

### 2. Improving Content
1. Fork the repository.
2. Create a new branch for your feature or fix: `git checkout -b feature/improvement-name`.
3. Make your changes in the relevant `.qmd` files.
4. Commit your changes using Semantic Commit Messages (see below): `git commit -m "feat: brief description of changes"`.
5. Push to your fork and submit a Pull Request.

### 3. Adding Translations
This project uses **Quarto Profiles** to support multiple languages. To start a new translation:
- Create a new language sub-directory under `docs/` (e.g., `docs/es/`).
- Create a corresponding profile configuration file at the root (e.g., `_quarto-es.yml`).
- Update `index.qmd` to conditionally include the new language's introduction (e.g., using `::: {.content-visible when-profile="es"}`).
- Ensure that the structure of chapters remains consistent with the main version.

## Technical Guidelines
- **Markdown:** Use standard Quarto-flavored Markdown.
- **Quenya Script:** When using Tengwar, ensure proper Unicode standards or provide transliterations to maintain accessibility.
- **Citations:** Always cite the source for linguistic interpretations (e.g., *The History of Middle-earth*, *Parma Eldalamberon*, etc.).

### Semantic Commit Messages
This repository relies on **Semantic Commit Messages** to automatically generate the `CHANGELOG.md` during releases. It is highly important that your commits follow this convention so your changes are categorized correctly.

Use the following prefixes in your commit messages:
- `feat:` for new features or lessons (appears under **Added** in the changelog)
- `fix:` for bug or typo fixes (appears under **Fixed**)
- `sec:` or `security:` for security updates (appears under **Security**)
- `deprecate:` or `remove:` for deprecations and removals
- `chore:`, `docs:`, `style:`, `test:`, `ci:`, `build:`, `refactor:`, `perf:` for internal changes (appears under **Changed**)

*Example:* `git commit -m "fix: corrected typo in the Tengwar chart"`

## Code of Conduct
Please be respectful and constructive in all interactions. Our goal is to create a welcoming environment for all fans of Tolkien’s languages. For more details, please refer to the [CODE_OF_CONDUCT.md](https://github.com/brunopacheco1/ma-quetelye-quenya/blob/main/CODE_OF_CONDUCT.md) file.

## Attribution
By contributing, you agree that your contributions will be licensed under the project's [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/)
