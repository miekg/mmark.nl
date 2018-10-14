---
title: "Mmark markdown output"
date: 2018-10-10T07:10:51+01:00
---

The latest mmark versions gained a new renderer: `-markdown` that outputs markdown *again.*
You can use this to autoformat the contents in your editor.
<!--more-->

See these two asciinema renderings, one where [we format the entire
file](https://asciinema.org/a/OKoLdyfS3q1ZdLFhkRRqLlrpr) and another to [reformat
a table](https://asciinema.org/a/bG7CydhptyJdGwyAkZJ9GLT3a).

For VIM you can use the following config:

~~~ vimscript
function! MmarkFmt ()
    let l = line(".")
    let c = col(".")
    silent !clear
    execute "%!" . "mmark -markdown"
    redraw!
    call cursor(l, c)
endfunction

au FileType pandoc command! Fmt call MmarkFmt()
au FileType markdown command! Fmt call MmarkFmt()
let mmark = "mmark -markdown -width 100"
au FileType pandoc set formatprg=mmark
au FileType markdown set formatprg=mmark
~~~
