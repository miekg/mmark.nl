---
title: "Quick Start"
date: 2018-08-07T14:05:51+01:00
aliases: [/start/]
---

The easiest way to get started is to download one of the [precompiled
binaries](https://github.com/mmarkdown/mmark/releases).

~~~ sh
% wget https://github.com/mmarkdown/mmark/releases/download/v1.9.93/mmark_1.9.93_linux_amd64.tgz
% tar xvf mmark_1.9.93_linux_amd64.tgz
mmark
% ./mmark -version
1.9.93
~~~

Now with `./mmark test.md` you render *test.md* to RFC 7991 XML (xml2rfc version 3), let's take
a look at test.md. For xml2rfc version 2, just use the `-2` flag.

~~~ markdown
%%%
Title = "Mmark Document"
%%%

.# Abstract

This is a small test document.

{mainmatter}

# First Section

Hi! *from* Mmark.
~~~

The text between `%%%` is the title block. For a real I-D this needs to be expanded quite
considerably, but for now it will suffice. Next is the abstract of the document, which is started
with `.#` to signal a "special" heading. The title block and abstract are part of the front matter
of the document which is opened. To start the *main* matter of the doc we use `{mainmatter}`
And lastly we start a "real" section with some text.

If we render this (`./mmark test.md`), we get this XML:

~~~ xml
<?xml version="1.0" encoding="utf-8"?>
<!-- name="GENERATOR" content="github.com/mmarkdown/mmark markdown processor for Go" -->
<rfc version="3" ipr="trust200902" submissionType="IETF" xml:lang="en" consensus="false" xmlns:xi="http://www.w3.org/2001/XInclude">

<front>
<title>Mmark Document</title><seriesInfo></seriesInfo>
<date year="2018" month="8" day="21"></date>
<area>Internet</area>
<workgroup></workgroup>

<abstract>
<t>This is a small test document.</t>
</abstract>

</front>

<middle>

<section><name>First Section</name>
<t>Hi! <em>from</em> Mmark.</t>
</section>

</middle>

</rfc>
~~~

Note that this can't be converted with `xml2rfc --v3` because we're missing various front matter
elements, notable the `<seriesInfo>` and there are no authors specified.

## Full I-D

We need to fill out the seriesInfo and add an author to the title block:

~~~ toml
%%%
Title = "Mmark Document"
area = "Internet"
workgroup = "Network Working Group"

[seriesInfo]
name = "Internet-Draft"
value = "draft-gieben-00"
stream = "IETF"
status = "informational"

date = 2018-08-21T00:00:00Z

[[author]]
initials="R."
surname="Gieben"
fullname="R. (Miek) Gieben"
%%%
~~~

And then generate the XML again and give it to `xml2rfc --v3`:

~~~
% ./mmark test.md > x.xml
% xml2rfc --v3 x.xml
Parsing file x.xml
x.xml(4): Warning: Expected a category, one of exp,info,std,bcp,historic, but found none
Created file x.txt
~~~

Where `x.txt` is the generated text of the I-D (showing small excerpt):

~~~ txt
Network Working Group                   R. Gieben
Internet-Draft                     21 August 2018
Expires: 22 February 2019


                      Mmark Document

Abstract

   This is a small test document.

Status of This Memo

...

Table of Contents

   1.  First Section

1.  First Section

   Hi! _from_ Mmark.
~~~

The [rfc](https://github.com/mmarkdown/mmark/tree/master/rfc) directory has a couple of (older) RFCs that
have been converted to Mmark for (syntax) inspiration, or take a look at the [syntax
document](/syntax).
