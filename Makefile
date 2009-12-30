# Simple Makefile for LaTeX documents

MARK	= `tput smso`
ENDMARK	= `tput rmso`

LATEX	= latex -shell-escape -interaction=nonstopmode
CHECKER = chktex -q -f "(%k) %f:%l:%c \"%r${MARK}%s${ENDMARK}%t\" - %m%N"
BIBTEX	= bibtex
DVIPDF	= dvipdf

SRC	:= $(shell grep -El '^[^%]*\\begin\{document\}' *.tex)
TRG	= $(SRC:%.tex=%.dvi)
PDF	= $(SRC:%.tex=%.pdf)

all 	: $(TRG)

test	: $(SRC)
	  @$(eval $@_OUTDIR := $(shell mktemp -d))
	  @$(LATEX) -output-dir=$($@_OUTDIR) $<	
	  @-rm -rf $@_OUTDIR

analyze	: $(SRC)
	  @$(CHECKER) $<

clean	: 
	  -rm -f $(TRG) $(PDF) $(TRG:%.dvi=%.log) $(TRG:%.dvi=%.toc) $(TRG:%.dvi=%.lof) \
		 $(TRG:%.dvi=%.lot) $(TRG:%.dvi=%.aux) $(TRG:%.dvi=%.idx) $(TRG:%.dvi=%.ind) \
		 $(TRG:%.dvi=%.ilg) *.pyg

$(TRG)	: %.dvi : %.tex
	  @$(LATEX) $<

$(PDF)	: %.pdf : %.dvi
	  @$(DVIPDF) $< $@

pdf	: $(PDF)
