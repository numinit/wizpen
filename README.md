# 🧙 wizpen

![The Time of the Dark, (C) 1982 Barbara Hambly. This cover art was great, 
let me know if I need to replace it.](img/logo.png)

A [Pigpen cipher](https://en.wikipedia.org/wiki/Pigpen_cipher)-inspired font,
originally created for a D\&D wizard spellbook. Unlike Pigpen, characters in
this font can share vertical and horizontal strokes while still being readable.

>Copying a spell into your spellbook involves reproducing the basic form of
>the spell, then deciphering the unique system of notation used by the wizard
>who wrote it (5E PHB, p. 114)

Based on the LaTeX [pigpen font](https://ctan.org/pkg/pigpen), originally
(C) 2008 Oliver Corff. This is version 1.2.0. Unlike the original, it is
generated entirely with a Ruby script.

You can use a package like `microtype` to add spacing between characters.
Both "expanded" and "compact" examples are shown below. Regardless of which
you use, one of my design goals was to allow the font to easily be read once
you know the basic scheme.

![key](img/key.png)

Note that uppercase `A-R` are rendered with two dots to mark the center of each
letter, and lowercase `a-r` are rendered with one dot. `S-Z` and `s-z` are
rendered with no dots, because they would get in the way of the diagonals.

If you don't like the dots, just comment out the `dotted` and `double_dotted`
lines in the generator script (see "Modifying the font" section below).

Also, `1-9` is just the negative space on `A-J`, and `0` is the negative space
on `Z`.

## Using the provided TTF or OTF

Just [download it](https://github.com/numinit/wizpen/tree/master/fonts)
and install it. It's that easy.

## Shoutouts

* DMs and brewers at [Battlemage Brewery](http://battlemagebrewing.com/)
  in San Diego, California
* dc858 folks (especially ice)
* Distractions, Inc for peer review and feedback

## Build prereqs

For just building LaTeX documents:

* metafont (for rendering the font in TeX)
* lualatex (for syntax highlighting important terms in D\&D spells)
* ruby (for building the metafont definition)

For building the font in TTF and OTF formats:

* mf2pt1
* fontforge

## Building

LaTeX files:

* `make`: Build everything
* `make clean`: Clean everything
* `make redo`: Run `make clean` and `make all`
* `make spellbook` or `make spellbook-redo`: Make the provided example
  spellbook.

TTF and OTF files:

* `make font`: Build the font into TTF and OTF files. This will take a while.

## Using the LaTeX metafont

Create a `texmf` folder like the one here (or just copy it) and
`export TEXMFHOME=mytexmf` before running `pdflatex`.

An example document will look like this:

```tex
\documentclass{article}

\usepackage[top=0.125in,bottom=0.125in,left=0.125in,right=0.125in]{geometry}
\usepackage[letterspace=150]{microtype}
\usepackage{setspace}

\usepackage{wizpen}

\begin{document}

{
    % Uncomment the \lsstyle to add a little spacing between symbols
    \Large \wizpenfont \noindent %\lsstyle
    ABCDEFGHI \enspace JKLMNOPQR \enspace STUV \enspace WXYZ \\ \\
}

\end{document}
```

## Example

Check `spellbook.tex` for spoilers on what all these actually say.

![example](img/example.png)

## Modifying the font

`script/wizpen.rb` is how the font gets generated (check the makefile).
If you want to modify it, edit that file, and the font will be regenerated
at the next `make`.

That code is pretty messy, but produces the whole font from an algorithm.

## License

Licensed under the [LaTeX Project Public License](https://ctan.org/license/lppl):
See [LICENSE](LICENSE)

