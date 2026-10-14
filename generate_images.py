# SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu)
#
# SPDX-License-Identifier: Apache-2.0
"""Generate the book's pictures from the paste-ready prompts with Gemini's API.

Every ```text block in a prompts file (by default raw_images/prompts/parande_1.md)
is one picture. The script adds the picture guide's negative prompt and a
reference picture of the cast, sends it to Gemini, and saves what comes back
in raw_images/generated/ for review. That folder is not committed and
compress_images.py does not read it, so nothing in the book changes until a
picture has been checked and moved into place (see raw_images/prompts/README.md).

    export GEMINI_API_KEY=...                 # https://aistudio.google.com/apikey
    python3 generate_images.py --dry-run      # list the pictures, no API call
    python3 generate_images.py                # one of each picture
    python3 generate_images.py --only 5.3 cover --count 3

Only the Python standard library is used. Google bills every picture made.
"""
import argparse
import base64
import json
import os
import pathlib
import re
import sys
import time
import unicodedata
import urllib.error
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent
PROMPTS = ROOT / "raw_images" / "prompts" / "parande_1.md"
GUIDE = ROOT / "raw_images" / "prompts" / "README.md"
REFERENCE = ROOT / "raw_images" / "parande_1_essi.jpeg"
OUTPUT = ROOT / "raw_images" / "generated"
API = "https://generativelanguage.googleapis.com/v1beta"
# The model the existing pictures were made with (Gemini 3 Pro Image).
MODEL = "gemini-3-pro-image-preview"
ASPECTS = {"1:1", "2:3", "3:2", "3:4", "4:3", "4:5", "5:4", "9:16", "16:9", "21:9"}
REFERENCE_NOTE = (
    "The attached picture is a reference for the drawing style and for each "
    "character's face, hair, ears and clothes. Keep the characters consistent "
    "with it, but do not copy its composition, setting or poses."
)

HEADING = re.compile(r"^(#{2,3})\s+(\d+(?:\.\d+)?)\.?\s+(.*)$")


def ascii_name(text):
    """'*amaurë*' -> 'amaure'."""
    text = unicodedata.normalize("NFKD", text)
    text = "".join(c for c in text if not unicodedata.combining(c))
    return re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")


def negative_extras(section_text):
    """The words after 'plus' in a section's 'Negative prompt:' line."""
    match = re.search(r"Negative prompt:.*?plus\s+`([^`]*)`", section_text, re.S)
    return " ".join(match.group(1).split()) if match else ""


def read_guide_negative(path):
    """The negative prompt the picture guide gives for every picture."""
    text = path.read_text(encoding="utf-8")
    match = re.search(r"Negative prompt for every picture:\s*```text\n(.*?)```", text, re.S)
    return " ".join(match.group(1).split()) if match else ""


def split_sections(text):
    """The '## N.' sections of a prompts file, as (number, title, lines)."""
    sections, current = [], None
    for line in text.splitlines():
        match = HEADING.match(line)
        if match and len(match.group(1)) == 2:
            current = (match.group(2), match.group(3), [])
            sections.append(current)
        elif current is not None:
            current[2].append(line)
    return sections


def make_job(job_id, name, section, prompt, section_text):
    """A picture to make; the aspect ratio is the last one the prompt names."""
    ratios = re.findall(r"\b(\d{1,2}:\d{1,2})\b", prompt)
    return {"id": job_id, "name": name, "section": section, "prompt": prompt,
            "aspect": ratios[-1] if ratios and ratios[-1] in ASPECTS else None,
            "negative_extra": negative_extras(section_text)}


def section_jobs(num, title, lines):
    """One job per ```text block of a section; a '### N.M' heading names its block."""
    file_match = re.search(r"`([^`]+?)\.\w+`", title)
    base = file_match.group(1) if file_match else ascii_name(title)
    section_text = "\n".join(lines)
    jobs, job_id, name, block = [], num, base, None
    for line in lines:
        if block is None:
            match = HEADING.match(line)
            if match:
                job_id = match.group(2)
                name = f"{base}_{job_id.split('.')[-1]}_{ascii_name(match.group(3))}"
            elif line.startswith("```text"):
                block = []
        elif line.startswith("```"):
            jobs.append(make_job(job_id, name, num, "\n".join(block).strip(), section_text))
            block = None
        else:
            block.append(line)
    return jobs


def read_jobs(path):
    """Every picture in a prompts file: its id ('4', '5.1'), file name and prompt."""
    text = path.read_text(encoding="utf-8")
    return [job for section in split_sections(text) for job in section_jobs(*section)]


def full_prompt(job, guide_negative, with_reference):
    """The text sent to the model: the block, what to avoid, the reference note."""
    avoid = ", ".join(x for x in (guide_negative, job["negative_extra"]) if x)
    parts = [job["prompt"]]
    if avoid:
        parts.append("Avoid: " + avoid + ".")
    if with_reference:
        parts.append(REFERENCE_NOTE)
    return "\n\n".join(parts)


def call_api(url, key, body=None, tries=4):
    """POST (or GET without body) to the Gemini API, retrying on overload."""
    data = json.dumps(body).encode("utf-8") if body is not None else None
    request = urllib.request.Request(url, data=data, headers={
        "x-goog-api-key": key, "Content-Type": "application/json"})
    for attempt in range(tries):
        try:
            with urllib.request.urlopen(request, timeout=600) as response:
                return json.load(response)
        except urllib.error.HTTPError as error:
            detail = error.read().decode("utf-8", "replace")
            if error.code in (429, 500, 503) and attempt < tries - 1:
                wait = 20 * (attempt + 1)
                print(f"  API busy ({error.code}), retrying in {wait} s")
                time.sleep(wait)
                continue
            hint = "  Run with --list-models to see the model names." if error.code == 404 else ""
            raise SystemExit(f"Gemini API error {error.code}: {detail[:800]}{hint}") from error
    raise SystemExit("Gemini API: no answer")


def images_in(response):
    """(bytes, mime type) of the final images in a response, and any text."""
    images, texts = [], []
    for candidate in response.get("candidates", []):
        for part in candidate.get("content", {}).get("parts", []):
            if part.get("thought"):
                continue
            inline = part.get("inlineData") or part.get("inline_data")
            if inline:
                mime = inline.get("mimeType") or inline.get("mime_type") or "image/png"
                images.append((base64.b64decode(inline["data"]), mime))
            elif part.get("text"):
                texts.append(part["text"].strip())
        if not images and candidate.get("finishReason"):
            texts.append("finish reason: " + candidate["finishReason"])
    if not response.get("candidates") and response.get("promptFeedback"):
        texts.append("prompt feedback: " + json.dumps(response["promptFeedback"]))
    return images, texts


def free_path(name, ext):
    """raw_images/generated/<name>-<n>.<ext> that does not exist yet."""
    n = 1
    while (OUTPUT / f"{name}-{n}.{ext}").exists():
        n += 1
    return OUTPUT / f"{name}-{n}.{ext}"


def request_body(job, prompt, args, references):
    """The generateContent request for one picture."""
    parts = [{"text": prompt}]
    for data, mime in references:
        parts.append({"inline_data": {"mime_type": mime, "data": data}})
    image_config = {}
    if job["aspect"]:
        image_config["aspectRatio"] = job["aspect"]
    if args.image_size:
        image_config["imageSize"] = args.image_size
    return {"contents": [{"role": "user", "parts": parts}],
            "generationConfig": {"responseModalities": ["TEXT", "IMAGE"],
                                 "imageConfig": image_config}}


def generate(job, prompt, args, key, references):
    """Ask for one picture and save it; returns the saved path or None."""
    body = request_body(job, prompt, args, references)
    response = call_api(f"{API}/models/{args.model}:generateContent", key, body)
    images, texts = images_in(response)
    for text in texts:
        print("  model says: " + text[:300])
    if not images:
        print("  no picture came back")
        return None
    data, mime = images[-1]
    ext = {"image/jpeg": "jpg", "image/webp": "webp"}.get(mime, "png")
    path = free_path(job["name"], ext)
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    return path


def list_models(key):
    """Print the models that can make pictures."""
    response = call_api(f"{API}/models?pageSize=1000", key)
    for model in response.get("models", []):
        name = model["name"].removeprefix("models/")
        if "image" in name and "generateContent" in model.get("supportedGenerationMethods", []):
            print(name)


def parse_args():
    """Command-line options."""
    parser = argparse.ArgumentParser(description=__doc__.split("\n", 1)[0])
    parser.add_argument("--prompts", type=pathlib.Path, default=PROMPTS,
                        help="prompts file (default: %(default)s)")
    parser.add_argument("--only", nargs="+", metavar="ID",
                        help="pictures to make, by number or name, e.g. 4 5.1 cover")
    parser.add_argument("--count", type=int, default=1,
                        help="versions of each picture to make (default: 1)")
    parser.add_argument("--model", default=MODEL, help="Gemini model (default: %(default)s)")
    parser.add_argument("--image-size", default="2K", choices=["1K", "2K", "4K", ""],
                        help="output size, for models that support it; '' to leave it out"
                             " (default: 2K)")
    parser.add_argument("--reference", type=pathlib.Path, action="append",
                        help=f"reference picture of the cast (default: {REFERENCE.name});"
                             " repeat for more")
    parser.add_argument("--no-reference", action="store_true",
                        help="send no reference picture")
    parser.add_argument("--dry-run", action="store_true",
                        help="list the pictures and exit without calling the API")
    parser.add_argument("--show-prompts", action="store_true",
                        help="with --dry-run, print each full prompt")
    parser.add_argument("--list-models", action="store_true",
                        help="print the Gemini models that make pictures and exit")
    return parser.parse_args()


def select_jobs(jobs, only):
    """The jobs named by --only (number, section, name or name prefix)."""
    if not only:
        return jobs
    wanted = {w.lower() for w in only}
    return [j for j in jobs
            if wanted & {j["id"], j["section"], j["name"], j["name"].split("_")[0]}]


def load_references(args):
    """The reference pictures as (base64 text, mime type), and their paths."""
    paths = [] if args.no_reference else (args.reference or [REFERENCE])
    references = []
    for path in paths:
        mime = "image/png" if path.suffix.lower() == ".png" else "image/jpeg"
        references.append((base64.b64encode(path.read_bytes()).decode("ascii"), mime))
    return references, paths


def main():
    """Make the pictures."""
    args = parse_args()
    key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    if args.list_models:
        if not key:
            raise SystemExit("Set GEMINI_API_KEY first.")
        list_models(key)
        return

    jobs = select_jobs(read_jobs(args.prompts), args.only)
    if not jobs:
        raise SystemExit("No pictures match; run with --dry-run to see their numbers and names.")
    references, reference_paths = load_references(args)
    guide_negative = read_guide_negative(GUIDE)

    total = len(jobs) * args.count
    print(f"{len(jobs)} pictures x {args.count} = {total} requests to {args.model}, "
          f"size {args.image_size or 'default'}, "
          f"reference: {', '.join(p.name for p in reference_paths) or 'none'}")
    for job in jobs:
        print(f"  {job['id']:>4}  {job['name']:<22} {job['aspect'] or 'default'}")
        if args.dry_run and args.show_prompts:
            print("\n" + full_prompt(job, guide_negative, bool(references)) + "\n")
    if args.dry_run:
        return
    if not key:
        raise SystemExit("Set GEMINI_API_KEY first (https://aistudio.google.com/apikey).")

    saved = []
    for job in jobs:
        prompt = full_prompt(job, guide_negative, bool(references))
        for n in range(args.count):
            print(f"{job['id']} {job['name']} ({n + 1}/{args.count})")
            path = generate(job, prompt, args, key, references)
            if path:
                print(f"  saved {path.relative_to(ROOT)}")
                saved.append(path)
    print(f"\n{len(saved)} of {total} pictures saved in {OUTPUT.relative_to(ROOT)}/")
    if len(saved) < total:
        sys.exit(1)


if __name__ == "__main__":
    main()
