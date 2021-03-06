---
title: "Mmark markdown filters"
date: 2018-10-17T07:10:51+01:00
---

The [mmark-filter command](https://github.com/mmarkdown/filter) allows you to *rewrite* the input
markdown to new markdown.

<!--more-->

Right now it contains a couple of plugins, of which the *exec* plugin is the most interesting one.

## *Exec*

The *exec* plugin will check if a code block has a `exec:CMD` language tag. If found the the
following steps will be performed:

1. `CMD` will be executed with the contents of the code block piped to it's standard input.

1. The ouput from `CMD` (if any) will be used to construct a data URI.

1. The code block will then be deleted and *replaced* with an image containing the data URI.

### Usage

Say you have the following little script that calls `dot`:

~~~ sh
#!/bin/bash
dot -Tpng
~~~

And this markdown:

~~~ markdown
This was code block:

``` exec:./dot.sh
digraph D {
  A [shape=diamond]
  B [shape=box]
  C [shape=circle]
  A -> B [style=dashed, color=grey]
  A -> C [color="black:invis:black"]
  A -> D [penwidth=5, arrowhead=none]
}
```
~~~

Note the `exec:./dot.sh` line that tells the filter to run `dot.sh` with the contents of the
codeblock. Putting this in a `test.md` file, you can then run:

~~~ sh
./filter -p exec < test.md | mmark -html > out.html
~~~

With the HTML looking like:

<p>This was code block:</p>

<p><img src="data:image/png;base64,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" alt="" /></p>

## *Protocol*

The *protocol* plugin can be used to run [protocol](http://www.luismg.com/protocol/) that allows for
generating ASCII-art protocol diagrams for code blocks.

Just put the command line you need to run for `protocol` in a code block, set the language to
"protocol" and run the filter. It will then replace the code block's content with the output from
protocol, i.e. the generated diagram.

### Usage

This markdown file:

~~~
We describe the following protocol:

``` protocol
Source:16,TTL:8,Reserved:40
```
Figure: This is a protocol.
~~~

Will be transformed with `filter -p protocol < protocol.md`, to:

~~~
We describe the following protocol:

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|             Source            |      TTL      |               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+               +
|                            Reserved                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
Figure: This is a protocol.
~~~
