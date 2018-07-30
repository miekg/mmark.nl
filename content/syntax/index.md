---
title: "Syntax"
date: 2018-07-22T14:05:51+01:00
draft: false
---

# Syntax

See [this document](https://github.com/miekg/mmark/wiki/Syntax) for the current syntax of Mmark. For
mmark2 this will be slightly changes and streamlined.

This document describes all the syntax elements that can be used in Mmark. Mmark's syntax is based
on the ["standard" Markdown syntax](https://daringfireball.net/projects/markdown/syntax).

It adds numerous enhancements to make it suitable for writing (IETF) Internet Drafts and even
complete books. It <strike>steals</strike> borrows syntax elements from [pandoc], [kramdown],
[leanpub], [asciidoc], [PHP markdown extra] and [Scholarly markdown].

[kramdown]: https://kramdown.gettalong.org/
[leanpub]: https://leanpub.com/help/manual
[asciidoc]: http://www.methods.co.nz/asciidoc/
[PHP markdown extra]: http://michelf.com/projects/php-markdown/extra/
[pandoc]: http://johnmacfarlane.net/pandoc/
[CommonMark]: http://commonmark.org/
[Scholarly markdown]: http://scholarlymarkdown.com/Scholarly-Markdown-Guide.html

This document is loosely based on the excellent syntax document from
[kramdown](http://kramdown.gettalong.org/syntax.html) and
[pandoc](http://pandoc.org/README.html).

In this document we start at the highest level, i.e. the title block and coarse document structure.
From there we zoom in on the smaller parts that make up a document.

# Changes from V1

* Extended tables syntax.
* Including files.
* Title Blocks needs to be sandwitched between `%%%`, the prefix `%` does not work anymore.


# Mmark V2 Syntax

## Title Block

A Title Block contains a document's meta data; title, authors, date and other elements. The elements
that can be specified are copied from the [xml2rfc v2
standard](https://tools.ietf.org/html/rfc7749). More on these below. The complete title block is
specified in [TOML](https://github.com/toml-lang/toml).

The title block itself needs three or more `%`'s at the start and end of the block. A minimal title
block would look like this:

~~~
%%%
title = "Foo Bar"
%%%
~~~
Indentation does not matter, so this is also legal:

~~~
%%%
    title = "My Awesome Title"
%%%
~~~

Doing so make the title block look better in Github (which does not know how to render such a block).

### Elements of the Title Block

An I-D needs to have a Title Block with the following items filled out:

* title
* abbrev
* category
* docName
* updates/obsoletes
* ipr
* area
* workgroup
* keyword
* date
* author(s) section

An example would be:

~~~
%%%
title = "Using mmark to create I-Ds and RFCs"
abbrev = "mmark2rfc"
category = "info"
docName = "draft-gieben-mmark2rfc-00"
updates = [1925, 7511]
ipr= "trust200902"
area = "Internet"
workgroup = ""
keyword = ["markdown", "xml", "mmark"]

date = 2014-12-10T00:00:00Z

[[author]]
initials="R."
surname="Gieben"
fullname="R. (Miek) Gieben"
#role="editor"
organization = "Atoom"
  [author.address]
  email = "miek@miek.nl"
%%%
~~~

An `#` acts as a comment in this block. TOML itself is specified [here](https://github.com/toml-lang/toml).

#### PIs

PI, stands "Process Instruction" and are an XML hack to enable/disable some features. Mmark
supports a subset of them:
~~~
toc, symrefs, sortrefs, compact, subcompact, private, topblock, header, footer, comments
~~~

PIs can be enabled in the title block, like so:
~~~
[pi]
toc = "no"
compact = "yes"
~~~

## Including Files

Including other files can done be with `{{filename}}`, if the path of `filename` is *not* absolute,
the filename is taken relative to *working directory* of the Mmark process. With `<{{filename}}`
your include filename as a code block. The main difference is that this include will be wrapped in
a code block.

The include may optionally be followed by a address specification in block quotes. This can detail
what lines to include, use a string to prefix each lines and more. For instance:
~~~
{{filename}}[3,4]
~~~

Only includes the lines 3 to 4 into the current document. The address syntax is described in
<https://godoc.org/golang.org/x/tools/present/>.

A preci

### Including code fragments

Using the syntax: `<{{code/hello.c}}[address]`, the file `code/hello.c` will be included into the
document as a code block. With `[address]` you can describe what the line number you want
to include. The address syntax is described in <https://godoc.org/golang.org/x/tools/present/>, the
OMIT keyword in the code also works.

Including a code snippet will look like this:

~~~
<{{test.go}}[/START OMIT/,/END OMIT/]
~~~

Where `test.go` looks like this:

``` go
tedious_code = boring_function()
// START OMIT
interesting_code = fascinating_function()
// END OMIT
```

Captioning works as well:

~~~
<{{test.go}}[/START OMIT/,/END OMIT/]
Figure: A sample function.
~~~

And the "[address]" may be omitted: `<{{test.go}}`. This includes the entire file.

The `prefix` IAL can be used:

~~~
{prefix="S: "}
<{{test.go}}
~~~

Will cause `test.go` to be included with each line being prefixed with `S: `.


## Document Divisions

Mmark support three document divisions, front matter, main matter and the back matter. Mmark
automatically starts the front matter for you *if* the document has a title block. Switching
divisions can be done with `{frontmatter}`, `{mainmatter}` and `{backmatter}`. This must be the only
thing on the line.

If the document has a [title block](#title-block) the front matter is already open. Closing the
front matter can only be done by starting the main matter with `{mainmatter}`. Any open "matters"
are closed when the document ends.

## Parts

Starting a new part of the document is similar to starting a new section, the syntax reflects that.
A new part is started with `-# PartName`

Specifying a part ID can be done with `-# PartName {#part1}` as is normal for headings
(see [headers](#headers).

## Special Headers and Notes

In some output formats (notably the IETF ones), the abstract is important and typeset differently.
In Mmark you signify it by using the special header syntax: `.# Abstract`. Note that the header name
must be (when lowercased) equal to "abstract".

`.# Preface` is another special header that is supported.

If you use a special header and the name is not "Abstract" or "Preface" it is considered a
[note](https://tools.ietf.org/html/rfc7749#section-2.24): a numberless section.

IDs (`{#id}`) after the title are supported.

## Headers

Mmark support the standard markdown headers: atx headers and setext.

Mmark supports a nice way for explicitly setting the header ID which is taken from [PHP Markdown
Extra]. If you follow the header text with an opening curly bracket (separated from the
text with a least one space), a hash, the ID and a closing curly bracket, the ID is set on the
header. If you use the trailing hash feature of atx style headers, the header ID has to go after the
trailing hashes. For example:

    Hello        {#id}
    -----

    # Hello      {#id}

    # Hello #    {#id}

If there is no explicit header ID, an ID is generated, this takes the name of header

* lowercases it
* replaces spaces with dashes
* removes any interpunction characters

For instance `# This is a Header!?!?` will become the ID: `this-is-a-header`. If an header solely
consists out of a number, ` # 3`, the implicit header ID, will be prefixed with "section-" and
then the number: `# 3`, becomes `section-3`.

If a header ID already exists, Mmark will add a sequence number, starting with `-1`. For example
a second header: `# 3` will become `section-3-1`.

## Paragraphs

Paragraphs are the most used block-level elements. One or more consecutive lines of text are
interpreted as one paragraph. The first line of a paragraph may be indented up to three spaces, the
other lines can have any amount of indentation.

You can separate two consecutive paragraphs from each other by using one or more blank lines. Notice
that a line break in the source does not mean a line break in the output. If you want to have an
explicit line break you need to end a line with two or more spaces or two backslashes. Note,
however, that a line break on the last text line of a paragraph is not possible.

## Captions

Mmark supports caption below [tables](#tables), [code blocks](#code-blocks) and [block quotes](#block-quotes).
Each of the elements has their own caption string: `Table:`, `Figure:` and `Quote:` respectively.
For a table:

~~~
Name    | Age
--------|-----:
Bob     | 27
Alice   | 23
Table: This is the table caption.
~~~

Or for a code block:

     ~~~ go
     func getTrue() bool {
         return true
     }
     ~~~
     Figure: This is a caption for a code block.

And for a quote:

     > Ability is nothing without opportunity.
     Quote: https://example.com -- Napoleon Bonaparte

## Comments

HTML comments are detected and copied to the final output form. There is one exception.
*If* a comments has the following structure: `<!--  Miek Gieben -- really? -->`, i.e. two strings
separated with ` -- `, this will be converted to a `cref` with the `source` attribute set to "Miek
Gieben" and the comment text set to "really?".

## Block Quotes

A block quote is started using the `>` marker followed by an optional space and the content of the
block quote. The marker itself may be indented up to three spaces. All following lines, whether they
are started with the block quote marker or just contain text, belong to the block quote.

The contents of a block quote are block-level elements. This means that if you are just using text as
content that it will be wrapped in a paragraph. For example, the following gives you one block quote
with two paragraphs in it:

    > This is a blockquote.
    >     on multiple lines
    that may be lazy.
    >
    > This is the second paragraph.

Since the contents of a block quote are block-level elements, you can nest block quotes and use other
block-level elements:

    > This is a paragraph.
    >
    > > A nested blockquote.
    >
    > ## Headers work
    >
    > * lists too
    >
    > and all other block-level elements

Note that the first space character after the `>` marker does *not* count when counting spaces for
the indentation of the block-level elements inside the block quote! So [code blocks](#code-blocks)
will have to be indented with five spaces, like this:

    > A code block:
    >
    >     func main() {}

If attribution for a block quote is needed you can add a caption. Just add the string `Quote:` below
the block quote.

### Captions

Directly below a quote block you may specify a "caption" which adds attribution to the above quote.

     > Ability is nothing without opportunity.
     Quote: https://example.com -- Napoleon Bonaparte

Where the quote will be attributed to Napoleon Bonaparte, pointing to the URL. The string ` -- ` is
important here, as it separates to two parts. A `Quote:` without a string containing ` -- ` is
ignored (currently - this may change in the future).

## Asides

Any text prefixed with `A>` will become an
[aside](https://developer.mozilla.org/en/docs/Web/HTML/Element/aside).

## Code Blocks

Code blocks can be used to represent verbatim text like markup, HTML or a program fragment.

### Standard Code Blocks

A code block can be started by using four spaces and then the text of the code block. All
following lines containing text must be indented by four spaces as well.
The indentation is stripped from each line of the code block.

Note that consecutive code blocks that are only separate by are merged together into one code block:

        Here comes some code

        This text belongs to the same code block.

If you want to have one code block directly after another one, just put a comment in between:

        Here comes some code
    <!-- nope -->
        This one is separate.

### Fenced Code Blocks

Mmark also supports an alternative syntax for code blocks which does not use indented blocks but
delimiting lines. The starting line needs to begin with three or more tilde characters (`~`) and the
closing line needs to have at least the number of tildes the starting line has.  Alternatively, code
blocks may start with three or more backtick characters (`` ` ``) and end with at least as many
backtick characters. Everything between is taken literally as with the other syntax but there is no
need for indenting the text. For example:

    ~~~~~~~~
    Here comes some code.
    ~~~~~~~~

If you need lines of tildes in such a code block, just start the code block with more tildes. For
example:

    ~~~~~~~~~~~~
    ~~~~~~~
    code with tildes
    ~~~~~~~~
    ~~~~~~~~~~~~~~~~~~

### Language of Code Blocks

    ~~~ ruby
    def what?
      42
    end
    ~~~

### Captions

And code block can be followed with the special string `Figure: `, which allows you to give it a
caption.

### Anchors

Anchors for code blocks are placed on the line before the block.

    {#anchor}
    ~~~ go
    Code block
    ~~~
    Figure: Caption text

### Callouts

In code blocks you can use the syntax angle bracket - number - angle bracket: `<number>` to create
a callout. Such callouts can be referenced in the text after the code block. An example, where
we first create a code block with two callouts and then reference the callouts in the text:
Note we call the `{callout="yes}"` an [Inline Attribute List](#inline-attribute-lists).

~~~
{callout="yes"}
    Code  <1>
    More  <1>
    Not a callout \<3>

As you can see in <1> but not in \<1>. There is no <3>.
~~~

This would be rendered:

~~~
     Code <1>
     Code <2>
     Not a callout <3>

As you can see in (1, 2) but not in <1>. There is no <3>.
~~~

You can escape a callout with a backslash. The backslash will be removed in the output (both in
source code and text). The callout identifiers will be *remembered* until the next code block.

There is currently no way to propose alternative syntax for the callout reference other than
`(number)`.

Note that callouts are only detected with the [IAL](#inline-attribute-lists)
`{callout="yes"}` or any other non-empty value is defined before the code block.

Using callouts in source code examples will lead to code examples that do not compile.
To fix this the callout needs to be placed in a comment, but then your source show useless empty comments.
To fix this Mmark can optionally detect (and remove!) the comment from the callout, leaving your
example pristine. This can be enabled using the [IAL](#inline-attribute-lists): `{callout="//"}`.
The allowed comment patterns are `//`, `#`, `/*`, `%`, `;`.

Prefixing code with a string on each line is possible with the IAL `prefix`:

~~~
{prefix="S: "}
line1
line2
~~~
Results in
~~~
S: line1
S: line2
~~~

## Figures and Subfigures

To group artworks and code blocks into figures, we need an extra syntax element.
[Scholarly markdown] has a neat syntax
for this. It uses a special section syntax and all images in that section become
subfigures of a larger figure. Disadvantage of this syntax is that it can not be
used in lists. Hence we use a quote like solution, just like asides,
but for figures: we prefix the entire paragraph with `F>`. Each of the images and
or code block included will be part of the same over arching figure.

Basic usage:

~~~
F> ~~~ ascii-art
F> +-----+
F> | ART |
F> +-----+
F> ~~~~
F> Figure: This caption is ignored in v3, but used in v2.
F>
F> ~~~ c
F> printf("%s\n", "hello");
F> ~~~
F>
Figure: Caption for both figures in v3 (in v2 this is ignored).
~~~

To summarize in v2 the inner captions *are* used and the outer one is discarded, for v3 it
is the other way around.

TODO(miek): HTML5 output

An image can be included in a subfigure:
`![Alt text](/path/to/img.jpg "Optional title")`

How the title exactly output is still a work in progress for all renderers.

## Lists

Mmark provides syntax elements for creating ordered and unordered lists as well as definition
lists.

### Ordered and Unordered lists

Both ordered and unordered lists follow the same rules.

A list is started with a list marker (in case of unordered lists one of `+`, `-` or `*` -- you can
mix them -- and in case of ordered lists a number followed by a period) followed by one space.

The leading tabs or spaces are stripped away from this first line of content to allow for a nice
alignment with the following content of a list item (see below).

The numbers used for ordered lists are *relevant*, Mmark will pay attention to the starting
number in an ordered list.

The following gives you an unordered list and an ordered list (that starts at 3):

    * mmark
    + black
    - friday

    3. black
    4. friday
    5. mmark

The are several ways to start an ordered lists. You can use numbers, roman numbers, letters and
uppercase letters. When using roman numbers and letter you must use two spaces after the dot or the
brace (the underscore signals a space here):

~~~
a)__Item1
A)__Item2
~~~

Since the content of a list item can contain block-level elements, you can do the following:

    *   First item

        A second paragraph

        * nested list

        > blockquote

    *   Second item

If you want to start a paragraph with something that looks like a list item marker, you need to
escape it. This is done by escaping the period in an ordered list or the list item marker in an
unordered list:

    1984\. It was great
    \- others say that, too!

## Example lists

An example lists is a document wide list that is subsequently numbered throughout the document. This
is the example list syntax [from
pandoc](http://johnmacfarlane.net/pandoc/README.html#extension-example_lists). References to example
lists work as well.

An example list is started when the identifier is the first word on a line:

    (@lista)  This is the start of an example list.

Note there must be two spaces after the identifier and the text of the list item.
You can then reference the list with `(@lista`) in running text.
Every time you reference a list it will point to the last list item, for example:

~~~
(@good)  This is a good example.

As (@good) illustrates

(@good)  Another example.

As (@good) also illustrates
~~~

Outputs:

~~~
(1)  This is a good example.

As (1) illustrates

(2)  Another example.

As (2) also illustrates
~~~

There is currently no way to propose alternative syntax for the reference other than `(number)`.

#### Styling Lists

If you need to style a list beyond what is possible, you can use a IAL:
`{style="format (%I)" type="(%I)"}`. This IAL is somewhat special as 'format' is used for XMLv2
output and 'type' for XMLv3. The *not*-used IAL is filtered out because otherwise that would lead
to XML validation failures.

### Definition Lists

Definition lists allow you to assign one or more definitions to one term.

A definition list is started when a normal paragraph is followed by a line with a definition marker
(a colon which may be optionally indented up to three spaces), then at least one space. The
following is a simple definition list:

    Mmark
    : A Markdown-superset converter

    Black Friday
    :     Another Markdown-superset converter

The definition for a term is made up of text and/or block-level elements. Multiple definitions for
single term can be done as such:

    Mmark
    : A Markdown-superset converter

    : A project on Github

    Black Friday
    :     Another Markdown-superset converter

### Task Lists

Task lists are supported:

~~~
- [ ] This is an incomplete task.
- [x] This is done.
~~~

Will be rendered (in HTML5) with checkboxes. The xml2rfc output will be as-is.

## Tables

Sometimes one wants to include simple tabular data in a Mmark document for which using a
full-blown HTML table is just too much. Mmark supports this with a simple syntax for ASCII
tables.

Tables can be created by drawing them in the input using a simple syntax:

```
Name    | Age
--------|-----:
Bob     | 27
Alice   | 23
```

The optional colon in the table header specifies the alignment of the column. Note that
these tables always need to have a header.

Tables can also have a footer: use equal signs instead of dashes for the separator,
to start a table footer. If there are multiple footer lines, the first one is used as a
starting point for the table footer.

```
Name    | Age
--------|-----:
Bob     | 27
Alice   | 23
======= | ====
Charlie | 4
```

The simple tables can't contain block level elements, for this you'll
need [block tables](#block-tables), although header and footer lines
can never contain block level elements.

### Block Tables

If a table is started with a *block table header*: starts with a pipe or plus sign and a minimum of
three dashes, it is a **Block Table**. A block table may include block level elements in each (body)
cell. If we want to start a new cell use the block table header syntax. In the example below we
include a list in one of the cells.


~~~
|-----------------+------------+-----------------+----------------|
| Default aligned |Left aligned| Center aligned  | Right aligned  |
|-----------------|:-----------|:---------------:|---------------:|
| First body part |Second cell | Third cell      | fourth cell    |
| Second line     |foo         | **strong**      | baz            |
| Third line      |quux        | baz             | bar            |
|-----------------+------------+-----------------+----------------|
| Second body     |            |                 |                |
| 2 line          |            |                 |                |
|=================+============+=================+================|
| Footer row      |            |                 |                |
|-----------------+------------+-----------------+----------------|
~~~

The above example table is rather time-consuming to create without the help of an ASCII table
editor. However, the table syntax is flexible and the above table could also be written like this:

~~~
|---
| Default aligned | Left aligned | Center aligned | Right aligned
|-|:-|:-:|-:
| First body part | Second cell | Third cell | fourth cell
| Second line |foo | **strong** | baz
| Third line |quux | baz | bar
|---
| Second body
| 2 line
|===
| Footer row
~~~

Column spanning (`colspan`) is supported as well, by using the
[multiple pipe syntax](http://bywordapp.com/markdown/guide.html#section-mmd-tables-colspanning), as
you can see in the next example:

~~~
Name    |Nickname  | Age
--------|----------|-----:
Bob     | The One  | 27
Alice   ||         | 23
======= |==========| ====
Charlie ||         | 4
~~~

### Captions

Captions for tables are placed on the line before the table.

    {#table-caption}
    Name | Value
    -|-:
    Bob | 1
    Alice | 2

## Horizontal Rules

Supported in the HTML5 output.

## Math Blocks

Use `$$` as the delimiter. If the math is part of a paragraph it will
be displayed in line, if the entire paragraph consists out of math it considered display
math. No attempt is made to parse what is between the `$$`.

## HTML/XML Blocks

An HTML block is potentially started if a line is encountered that begins with a non-span-level HTML
tag or a general XML tag (opening or closing) which may be indented up to three spaces.

The following HTML tags count as block-level HTML tags:

    blockquote del div dl fieldset form h1 h2 h3 h4 h5 h6 iframe ins math noscript ol pre p script
    style table ul article aside canvas figcaption figure footer header hgroup output progress
    section video

Mmark will mostly leave the contents inside the tags alone, except:

* When it detects an HTML comment (not really a block level element), see [Comments](#comments).
* A `<hr>` tag is seen.
* For XML output at `<br/>` (only exactly like that) is detected and an `<vspace/>` is outputted.
* A CDATA block.
* Or an [XML reference](#xml-references).

### XML References

Any XML reference fragment included *before* the back matter, can be used as a citation reference.
The syntax of the XML reference element is defined in [RFC
7749](https://tools.ietf.org/html/rfc7749#section-2.30). The `anchor` defined can be used in the
citation, in the example below that would be `[@pandoc]`.

~~~
<reference anchor='pandoc' target='http://johnmacfarlane.net/pandoc/'>
    <front>
        <title>Pandoc, a universal document converter</title>
        <author initials='J.' surname='MacFarlane' fullname='John MacFarlane'>
            <organization>University of California, Berkeley</organization>
            <address>
                <email>jgm@berkeley.edu</email>
                <uri>http://johnmacfarlane.net/</uri>
            </address>
        </author>
        <date year='2006'/>
    </front>
</reference>
~~~

Note that for citing I-Ds and RFCs you *don't* need to include any XML, as Mmark will pull these
automatically from their online location: or technically more correct: the xml2rfc post processor
will do this.

## Indices

Defining indices allows you to create an index. The define an index use the `(((item, subitem)))`
syntax. To make `item` primary, use an `!`: `(((!item, subitem)))`. Just `(((item)))` is allowed as
well.

## Citations

Mmark uses the citation syntax from Pandoc: `[@RFC2535 p. 23]`, the citation can either be
informative (default) or normative, this can be indicated by using the `?` or `!` modifier:
`[@!RFC2535]`. Use `[-@RFC1000]` to add the citation to the references, but suppress the output in
the document.

The "highest" modifier seen determines the final type, i.e. once a citation is declared normative it
will stay normative, but informative one will be "upgraded" to normative.

If you reference an RFC or I-D the reference will be added automatically.

For I-Ds you may want to add a draft sequence number, which can be done as such: `[@?I-D.blah#06]`.
If you reference an I-D *without* a sequence number it will create a reference to the *last* I-D in
citation index.

Once a citation has been defined (i.e. the reference anchor is known to Mmark) you can use
`@RFC2535` as a shortcut for the citation.

If you have (other) references that are not automatically added, you can include the raw XML in the
document (before the `{backmatter}`). Also see [XML references](#xml-references).

## Short References

Internal references use the syntax `[](#id)`, usually the need for the title within the brackets is
not needed, so Mmark has the shorter syntax `(#id)` to cross reference in the document.

Example:

~~~
My header {#header}

Lorem ipsum dolor sit amet, at ultricies ...
See Section (#header).
~~~

# Text Markup

These elements are all span-level elements and used inside block-level elements to markup text
fragments. For example, one can easily create links or apply emphasis to certain text parts.

Note that empty span-level elements are not converted to empty HTML tags but are copied as-is to the
output.

## Strike Through

Use two tildes to make mark text that should be crossed out: `~~crossed out text~~`.

## Super- and Subscript

For superscript use `^` and for subscripts use `~`. For example:

~~~
H~2~O is a liquid. 2^10^ is 1024.
~~~

Inside a super- or subscript you must escape spaces. Thus, if you want the letter P with 'a cat' in
subscripts, use `P~a\ cat~`, not `P~a cat~`.

## Links and Images

Three types of links are supported: automatic links, inline links and reference links.

### Automatic Links

This is the easiest one to create: Just surround a web address or an email address with angle
brackets and the address will be turned into a proper link. The address will be used as link target
and as link text. For example:

~~~
Information can be found on the <https://example.com> homepage.
You can also mail me: <mailto:me@example.com>
~~~

It is not possible to specify a different link text using automatic links, use the other link types
for this.

Mmark takes this one step further a link as `https://example.com` will be detected as well even
without any angle brackets.

### Inline Links

As the wording suggests, inline links provide all information inline in the text flow. Reference
style links only provide the link text in the text flow and everything else is defined
elsewhere. This also allows you to reuse link definitions.

An inline style link can be created by surrounding the link text with square brackets, followed
immediately by the link URL (and an optional title in single or double quotes preceded by at least
one space) in normal parentheses. For example:

~~~
This is [a link](http://golang.org) to a page.
A [link](../test "local URI") can also have a title.
And [spaces](link with spaces.html)!
~~~

Notes:

* The link text is treated like normal span-level text and therefore is parsed and converted.
  However, if you use square brackets within the link text, you have to either properly nest them or
  to escape them. It is not possible to create nested links!

  The link text may also be omitted, e.g. for creating link anchors.

* The link URL has to contain properly nested parentheses if no title is specified, or the link URL
  must be contained in angle brackets (incorrectly nested parentheses are allowed).

* The link title may not contain its delimiters and may not be empty.

### Reference Links

To create a reference style link, you need to surround the link text with square brackets (as with
inline links), followed by optional spaces/tabs/line breaks and then optionally followed with
another set of square brackets with the link identifier in them. A link identifier may not contain a
closing bracket and, when specified in a link definition, newline characters; it is also not case
sensitive, line breaks and tabs are converted to spaces and multiple spaces are compressed into one.
For example:

    This is a [reference style link][linkid] to a page. And [this]
    [linkid] is also a link. As is [this][] and [THIS].

If you don't specify a link identifier (i.e. only use empty square brackets) or completely omit the
second pair of square brackets, the link text is converted to a valid link identifier by removing
all invalid characters and inserting spaces for line breaks. If there is a link definition found for
the link identifier, a link will be created. Otherwise the text is not converted to a link.

### Link Definitions

The link definition can be put anywhere in the document. It does not appear in the output. A link
definition looks like this:

    [linkid]: http://www.example.com/ "Optional Title"

The link definition has the following structure:

* The link identifier in square brackets, optionally indented up to three spaces,
* then a colon and one or more optional spaces/tabs,
* then the link URL which must contain at least one non-space character, or a left angle bracket,
  the link URL and a right angle bracket,
* then optionally the title in single or double quotes, separated from the link URL by one or more
  spaces or on the next line by itself indented any number of spaces/tabs.

If you have some text that looks like a link definition but should really be a link and some text,
you can escape the colon after the link identifier:

    The next paragraph contains a link and some text.

    [Room 100]\: There you should find everything you need!

    [Room 100]: link_to_room_100.html

### Images

Images can be specified via a syntax that is similar to the one used by links. The difference is
that you have to use an exclamation mark before the first square bracket and that the link text of a
normal link becomes the alternative text of the image link. As with normal links, image links can be
written inline or reference style. For example:

    Here comes a ![smiley](../images/smiley.png)! And here
    ![too](../images/other.png 'Title text'). Or ![here].
    With empty alt text ![](see.jpg)

The link definition for images is exactly the same as the link definition for normal links. Since
additional attributes can be added via IALs, it is possible, for example, to specify
image width and height:

    {height="36px" width="36px"}
    Here is an inline ![smiley](smiley.png).

## Emphasis

Mmark supports two types of emphasis: light and strong emphasis. Text parts that are surrounded
with single asterisks `*` or underscores `_` are treated as text with light emphasis, text parts
surrounded with two asterisks or underscores are treated as text with strong emphasis. Surrounded
means that the starting delimiter must not be followed by a space and that the stopping delimiter
must not be preceded by a space.

Here is an example for text with light and strong emphasis:

    *some text*
    _some text_
    **some text**
    __some text__

The asterisk form is also allowed within a single word:

    This is un*believe*able! This d_oe_s not work!

## Code Spans

This is the span-level equivalent of the [code block](#code-blocks) element. You can markup a text
part as code span by surrounding it with backticks `` ` ``. For example:

    Use `<html>` tags for this.

Note that all special characters in a code span are treated correctly. For example, when a code span
is converted to HTML, the characters `<`, `>` and `&` are substituted by their respective HTML
counterparts.

To include a literal backtick in a code span, you need to use two or more backticks as delimiters.
You can insert one optional space after the starting and before the ending delimiter (these spaces
are not used in the output). For example:

    Here is a literal `` ` `` backtick.

## BCP 14/RFC 2119 Keywords

If an RFC 2119 word is found enclosed in `**` it will be rendered
as an `<bcp14>` element: i.e. `**MUST**` becomes `<bcp14>MUST</bcp14>`.

## HTML Spans

HTML tags cannot only be used on the block-level but also on the span-level. Span-level HTML tags
can only be used inside one block-level element, it is not possible to use a start tag in one block
level element and the end tag in another. If it looks like a syntactically correct HTML tag-pair
Mmark will leave it alone. Note that for XML output the tags and anything inside are stripped
from the output.

## Footnotes

Footnotes in Mmark are similar to reference style links and link definitions. You need to place
the footnote marker in the correct position in the text and the actual footnote content can be
defined anywhere in the document.

A marker in the text that will become a superscript number; a footnote definition that
A footnote looks like this:

    This is a footnote.[^1]

    [^1]: the footnote text.

Inline footnotes are also allowed (though, unlike regular notes, they cannot contain multiple
paragraphs). The syntax is as follows:

    Here is an inline note.^[Inlines notes are easier to write, since
    you don't have to pick an identifier and move down to type the
    note.]

Inline and regular footnotes may be mixed freely. Also note that the xml2rfc standard does not
support footnotes.

## Abbreviations

See <https://michelf.ca/projects/php-markdown/extra/#abbr>, any text defined by:

    *[HTML]: Hyper Text Markup Language

Allows you to use HTML in the document and it will be expanded to `<abbr title="Hyper Text Markup
Language">HTML</abbr>`. If you need text that looks like an abbreviation, but isn't, escape the
colon:

    *[HTML]\: HyperTextMarkupLanguage

## Inline Attribute Lists

This block-level element is used to attach attributes to another block-level element. An IAL
has to be put directly before a block-level element of which the attributes should be attached.
The full syntax is: `{#id .class key="value"}`. Values may be omitted `{.class}` is valid
as well. IAL are processed for the following elements:

* Tables
* Code Blocks and Fenced Code Blocks
* Lists
* Headers
* Images
* Quotes

For all other elements they are ignored, but not discarded. This means they will be applied to the
next element that *does* use the IAL!

Here are some examples for IALs:

~~~
{title="The blockquote title"}
{#myid}
> A blockquote with a title

{.go}
    Some code here
~~~

### Special IALs

TODO(miek): detail some IAL extra.

* Lists: `{style="format (%I)" type="(%I)"}`. TODO(miek): more
* Code blocks: ...?

# Bugs

* Citations must be included in the text before the `{backmatter}` starts. Otherwise they are not available in the appendix.
* Inline Attribute Lists must be given *before* the block element.
* HTML spans are not outputted in the XML renderers.
* Table header and footers can't contain block level elements.
* Subfigure and images need to be further clarified.
