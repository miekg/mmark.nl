---
title: "Plan"
date: 2018-07-22T14:05:51+01:00
draft: false
---

## Version 2 Plan

Mmark works fine, but has a few bugs and the code hasn't aged well. A long term plan
was to rewrite it once blackfriday v2 was stable. This never happened.

However [gomarkdown](https://github.com/gomarkdown/markdown) has finalized the never released
v2 version of blackfriday and provides a sane base to build upon.

We need to [decide](https://groups.google.com/forum/#!forum/mmark-discuss) what features to drop (or
not port immediately):

* extended table syntax (buggy in the current implementation)
* captions for quotes (split the string on ` -- `, a better syntax would be nicer here)

All other syntax features will be ported over as-is.

### Summary

* Use [gomarkdown](https://github.com/gomarkdown/markdown) as the base.
* Create a repository to github.com/mmarkdown/mmark, i.e. under the "mmarkdown" org.
* Focus on xml2rfc version 3 (drop v2 support) and HTML5.
* Start with porting features over, to see how this fares:
    * TOML titleblock
    * IAL (inline attribute lists) - this also has bugs in the current implementation.
    * Captions for figures and code blocks
* Upstream to gomarkdown (if possible).
