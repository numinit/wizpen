# wizpen

A [Pigpen cipher](https://en.wikipedia.org/wiki/Pigpen_cipher)-inspired font,
originally created for a D\&D wizard spellbook. Unlike Pigpen, characters in
this font can share vertical and horizontal strokes while still being readable.

>Copying a spell into your spellbook involves reproducing the basic form of
>the spell, then deciphering the unique system of notation used by the wizard
>who wrote it (5E PHB, p. 114)

Based on the LaTeX [pigpen font](https://ctan.org/pkg/pigpen), originally
(C) 2008 Oliver Corff. This is version 1.0.1.

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

## Shoutouts

* DMs and brewers at [Battlemage Brewery](http://battlemagebrewing.com/)
  in San Diego, California
* dc858 folks (especially ice)
* Distractions, Inc for peer review and feedback

## Build prereqs

* metafont
* pdflatex
* ruby (if you want to rebuild the font)

## Building

* `make`: Build everything
* `make clean`: Clean everything
* `make redo`: Run `make clean` and `make all`

## Using the font

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

## License

Licensed under the [LaTeX Project Public License](https://ctan.org/license/lppl):
See [LICENSE](LICENSE)

