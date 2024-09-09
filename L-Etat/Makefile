
MD=$(wildcard *.md)
CONTENT_TEX=$(patsubst %.md,%.tex,$(MD))

all: main.pdf
%.tex: %.md
	kramdown -o latex $< | tail -n +5 | sed 's/\\section{/\\chapter{/; s/\\subsection{/\\section{/; s/\\subsubsection{/\\subsection{/; s/\\paragraph{/\\subsubsection{/; s/\\subparagraph{/\\paragraph{/;'> $@

main.pdf: main.tex $(CONTENT_TEX)
	latexmk $<

booklet.pdf: booklet.tex main.pdf
	latexmk $<
booklet-16.pdf: booklet-16.tex main.pdf
	latexmk $<

clean:
	latexmk -c
dist-clean: clean
	latexmk -C
	rm -f $(CONTENT_TEX)
