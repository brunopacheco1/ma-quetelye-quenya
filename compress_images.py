# SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu|brunopacheco1@yahoo.com)
#
# SPDX-License-Identifier: Apache-2.0
import os
import shutil
from PIL import Image

# --- SETTINGS ---
INPUT_DIR = 'raw_images'
OUTPUT_DIR = 'images'
MAX_WIDTH = 2048            # Higher res for iPad/Retina displays
QUALITY = 80                # High quality JPG
OUTPUT_FORMAT = 'JPEG'      # Use JPEG for broader compatibility (like LaTeX)

def process_for_epub3():
    if os.path.exists(OUTPUT_DIR):
        shutil.rmtree(OUTPUT_DIR)
    os.makedirs(OUTPUT_DIR)

    for filename in os.listdir(INPUT_DIR):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
            path = os.path.join(INPUT_DIR, filename)
            
            with Image.open(path) as img:
                # 1. Resize while maintaining aspect ratio
                if img.width > MAX_WIDTH:
                    ratio = MAX_WIDTH / float(img.width)
                    new_height = int(float(img.height) * float(ratio))
                    img = img.resize((MAX_WIDTH, new_height), Image.Resampling.LANCZOS)

                # 2. Define output path
                base_name = os.path.splitext(filename)[0]
                output_path = os.path.join(OUTPUT_DIR, f"{base_name}.jpg")

                # 3. Save as JPEG with optimization
                if img.mode in ("RGBA", "P"):
                    img = img.convert("RGB")
                img.save(output_path, "JPEG", quality=QUALITY, optimize=True)
                
                # 4. Copy license file if it exists
                license_file = f"{filename}.license"
                license_path = os.path.join(INPUT_DIR, license_file)
                if os.path.exists(license_path):
                    output_license_path = f"{output_path}.license"
                    shutil.copy(license_path, output_license_path)

                new_size = os.path.getsize(output_path) / 1024
                print(f"✨ Processed {filename} -> {base_name}.jpg ({new_size:.1f} KB)")

if __name__ == "__main__":
    process_for_epub3()
