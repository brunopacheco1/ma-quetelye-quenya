# SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
#
# SPDX-License-Identifier: Apache-2.0
"""Write pandoc's default EPUB stylesheet to _epub-default.css.

Quarto runs this before every render (pre-render in _quarto.yml). The EPUB
needs a stylesheet of its own for the Tengwar font (epub-tengwar.css), and
listing any stylesheet under `css:` makes pandoc drop its default one. So the
book lists both, and this script copies the default from the pandoc that
Quarto bundles. The copy is not committed: it is pandoc's file, not ours.
"""
import os
import pathlib
import shutil
import subprocess

TARGET = pathlib.Path(os.environ.get("QUARTO_PROJECT_DIR", ".")) / "_epub-default.css"


def main():
    """Write the file, but only when it changed, so `quarto preview` does not loop."""
    quarto = (shutil.which("quarto", path=os.environ.get("QUARTO_BIN_PATH"))
              or shutil.which("quarto"))
    if quarto is None:
        raise SystemExit("epub_default_css.py: quarto not found")
    css = subprocess.run(
        [quarto, "pandoc", "--print-default-data-file", "epub.css"],
        check=True, capture_output=True, text=True,
    ).stdout
    if not TARGET.exists() or TARGET.read_text(encoding="utf-8") != css:
        TARGET.write_text(css, encoding="utf-8")


if __name__ == "__main__":
    main()
