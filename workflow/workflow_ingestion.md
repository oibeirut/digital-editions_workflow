---
title: "workflow_ingestion"
author: Till Grallert
date: 2018-11-19 12:16:10 +0200
---

1. Mark-up in Word according to some template
2. Convert .docx to .tei using oxGarage
3. Improve oxGarage output with custom XSLT
    1. `tei_map-word-styles-to-tei.xslt`:
        - map word styles to tei
    2. `tei_mark-up-with-regex.xslt`: adds mark-up based on regular expressions
    3. `tei_test-for-alphabet.xslt`: segments text nodes along whitespace and punctuation marks using `<tei:w>` and `<tei:pc>`, tries to establish the alphabet of the first letter of each word, and assigns a corresponding `@xml:lang` to `<tei:w>`
        - *NOTE*: oxGarage v2.15.0 seemingly wraps all non-Latin strings in `<tei:hi>` with Arabic script getting an additional `@dir="rtl"` (which does not validate against TEI_all). This would allow for easy mark-up with `@xml:lang`