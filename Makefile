
MD=$(wildcard *.md)
CONTENT_TEX=main.tex $(patsubst %.md,%.tex,$(MD))

all: a4.pdf a5.pdf a6.pdf a5-booklet_a4.pdf a6-booklet_a5.pdf a5-16let_a4.pdf a6-16let_a5.pdf a6-16let_a5-doublepages_a4.pdf
.PRECIOUS: %.tex
%.tex: %.md
	kramdown -o latex $< | tail -n +5 | sed 's/\\section{/\\chapter{/; s/\\subsection{/\\section{/; s/\\subsubsection{/\\subsection{/; s/\\paragraph{/\\subsubsection{/; s/\\subparagraph{/\\paragraph{/;'> $@

a4.pdf:
a5.pdf:
a5-booklet_a4.pdf:
a5-16let_a4.pdf:
a6.pdf:
a6-booklet_a5.pdf:
a6-16let_a5.pdf:
a6-16let_a5-doublepages_a4.pdf:

%.pdf: %.tex $(CONTENT_TEX)
	latexmk $*

%-booklet_a4.pdf: %-booklet_a4.tex %.pdf
%-booklet_a5.pdf: %-booklet_a5.tex %.pdf
%-16let_a4.pdf: %-16let_a4.tex %.pdf
%-16let_a5.pdf: %-16let_a5.tex %.pdf
%-doublepages_a4.pdf: %-doublepages_a4.tex %.pdf

.PRECIOUS: %-doublepages_a4.tex
%-doublepages_a4.tex: template/doublepages.tex.template %.pdf
	cat $< | sed 's/FORMAT/a4/;s/SOURCE/$*/' > $@

.PRECIOUS: %-booklet_a4.tex
%-booklet_a4.tex: template/booklet.tex.template %.pdf
	cat $< | sed 's/FORMAT/a4/;s/SOURCE/$*/' > $@
.PRECIOUS: %-booklet_a5.tex
%-booklet_a5.tex: template/booklet.tex.template %.pdf
	cat $< | sed 's/FORMAT/a5/;s/SOURCE/$*/' > $@

.PRECIOUS: %-16let_a4.tex
%-16let_a4.tex: template/n-let.tex.template %.pdf
	cat $< | sed 's/FORMAT/a4/;s/SOURCE/$*/;s/SIGNATURE/16/' > $@
.PRECIOUS: %-16let_a5.tex
%-16let_a5.tex: template/n-let.tex.template %.pdf
	cat $< | sed 's/FORMAT/a5/;s/SOURCE/$*/;s/SIGNATURE/16/' > $@



booklet.pdf: booklet.tex main.pdf
	latexmk $<
booklet-16.pdf: booklet-16.tex main.pdf
	latexmk $<

clean:
	latexmk -c
dist-clean: clean
	latexmk -C
	@# remove generated tex file
	rm -f *-booklet_a?.tex
	rm -f *-??let_a?.tex
	rm -f *-doublepages_a?.tex
