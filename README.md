# wizpen

A Pigpen-inspired font for D\&D wizard spellbooks. Unlike Pigpen, characters
can share vertical strokes while still being readable.

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

## Modifying the font

`script/wizpen.rb` is how the font gets generated (check the makefile).
If you want to modify it, edit that file, and the font will be regenerated
at the next `make`.
