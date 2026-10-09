-- SPDX-FileCopyrightText: 2026 Bruno Pacheco (https://bruno.pacheco.lu|brunopacheco1@yahoo.com)
--
-- SPDX-License-Identifier: Apache-2.0

-- Chapters are shared by every language profile, so they cannot carry alt
-- text in the reader's language. Each profile file (_quarto-<lang>.yml)
-- declares an `alt-text` map from image file name to alt text, and this
-- filter applies it to every image whose file name has an entry.

local alt_text = {}

local function basename(path)
  return path:match("([^/\\]+)$") or path
end

return {
  {
    Meta = function(meta)
      local map = meta["alt-text"]
      if map == nil then return nil end
      for name, value in pairs(map) do
        alt_text[name] = pandoc.utils.stringify(value)
      end
      return nil
    end,
  },
  {
    Image = function(img)
      local alt = alt_text[basename(img.src)]
      if alt == nil then return nil end
      img.attributes["fig-alt"] = alt
      img.attributes["alt"] = alt
      return img
    end,
  },
}
