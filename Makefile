.PHONY: all clean

all: presentation.pdf

presentation.pdf: presentation.tex
	LANG= latexmk $<

clean:
	latexmk -C
	rm -f *.bbl *.run.xml *.lol *.ist *.nav *.snm
