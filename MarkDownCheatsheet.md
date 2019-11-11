# Mark Down Cheatsheet 

## Headers

>\# H1
>
>\## H2
>
>\### H3
>
>\#### H4
>
>\##### H5
>
>\###### H6
>

# H1
## H2
### H3
#### H4
##### H5
###### H6

Alternatively, for H1 and H2, an underline-ish style:

>Alt-H1
>\======
>
>Alt-H2
>\------
>

Alt-H1
======

Alt-H2
------

## Emphasis

>Emphasis, aka italics, with \*asterisks* or \_underscores_.
>
>Strong emphasis, aka bold, with \**asterisks** or \__underscores__.
>
>Combined emphasis with \**asterisks and \_underscores_**.
>
>Strikethrough uses two tildes. \~~Scratch this.~~
>

Emphasis, aka italics, with *asterisks* or _underscores_.

Strong emphasis, aka bold, with **asterisks** or __underscores__.

Combined emphasis with **asterisks and _underscores_**.

Strikethrough uses two tildes. ~~Scratch this.~~


## Lists

1. First ordered list item
2. Another item
    * Unordered sub-list. 
1. Actual numbers don't matter, just that it's a number
    1. Ordered sub-list
4. And another item.  
   
   Some text that should be aligned with the above item.

* Unordered list can use asterisks
- Or minuses
+ Or pluses

## Links

>There are two ways to create links:
>
>\[I'm an inline-style link]\(https://www.google.com)
>
>URLs and URLs in angle brackets will automatically get turned into links. 
>http://www.example.com or \<http://www.example.com> and sometimes 
>example.com (but not on Github, for example).
>


There are two ways to create links.

[I'm an inline-style link](https://www.google.com)

URLs and URLs in angle brackets will automatically get turned into links. 
http://www.example.com or <http://www.example.com> and sometimes 
example.com (but not on Github, for example).

## Images

Here's our logo (hover to see the title text):

>Inline-style: 
\!\[alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

Inline-style: 
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

## Code and Syntax Highlighting

Code blocks are part of the Markdown spec, but syntax highlighting isn't. However, many renderers -- like Github's and Markdown Here -- support syntax highlighting. Markdown Here supports highlighting for dozens of languages (and not-really-languages, like diffs and HTTP headers); to see the complete list, and how to write the language names, see the highlight.js demo page.

>Inline \`code\` has \`back-ticks around\` it.

Inline `code` has `back-ticks around` it.

Blocks of code are either fenced by lines with three back-ticks ```.

>\```PowerShell\
>$String = 'I am a string'\
>Write-Output $String\
>\```

```PowerShell
$String = 'I am a string'
Write-Output $String
```
## Tables

Tables aren't part of the core Markdown spec, but they are part of GFM and Markdown Here supports them. 

The outer pipes (|) are optional, and you don't need to make the raw Markdown line up prettily. You can also use inline Markdownand colons can be used to align columns.

>\| Tables        | Are           | Cool  |\
>\| ------------- |:-------------:| -----:|\
>\| col 3 is      | right-aligned | $1600 |\
>\| col 2 is      | centered      |   $12 |\
>\| zebra stripes | are neat      |    $1 |

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

## Blockquotes

>\> Blockquotes are very handy in email to emulate reply text.

> Blockquotes are very handy in email to emulate reply text.

## Inline HTML

You can also use raw HTML in your Markdown, and it'll mostly work pretty well.

>\<dl>\
>  \<dt>Definition list\</dt>\
>  \<dd>Is something people use sometimes.\</dd>\
>  \<dt>Markdown in HTML\</dt>\
>  \<dd>Does *not* work **very** well. Use HTML \<em>tags\</em>.\</dd>\
>\</dl>
<dl>
  <dt>Definition list</dt>
  <dd>Is something people use sometimes.</dd>

  <dt>Markdown in HTML</dt>
  <dd>Does *not* work **very** well. Use HTML <em>tags</em>.</dd>
</dl>

## Horizontal Rule

>Three or more:
>- Hyphens\
>\---
>- Asterisks\
>\***
>- Underscores\
>\___

Three or more:

- Hyphens
---
- Asterisks
***
- Underscores
___

## Task Lists

A task list creates checkboxes that can be checked off by collaborators in a given repository. They're very handy for tracking Issues, Pull Requests, and any to-do item.

If you include a task list in the first comment of an Issue, you will get a handy progress indicator in your Issue list

>- [x] this is a complete item
>- [ ] this is an incomplete item
>- [x] \[links](url), \**formatting**, and \<del>tags\</del> supported
>- [x] list syntax required (any unordered or ordered list supported)
>   - Like this

- [x] this is a complete item
- [ ] this is an incomplete item
- [x] [links](url), **formatting**, and <del>tags</del> supported
- [x] list syntax required (any unordered or ordered list supported)
  - Like this