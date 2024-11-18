
SRC=src
BUILD=build
PDFOUT=pdf/
MD=$(wildcard $(SRC)/*.md)
CONTENT_TEX=main.tex $(patsubst %.md,%.tex,$(MD))

all: $(PDFOUT)a4.pdf $(PDFOUT)a5.pdf $(PDFOUT)a6.pdf $(PDFOUT)a5-booklet_a4.pdf $(PDFOUT)a6-booklet_a5.pdf $(PDFOUT)a5-16let_a4.pdf $(PDFOUT)a6-16let_a5.pdf $(PDFOUT)a6-16let_a5-doublepages_a4.pdf
.PRECIOUS: %.tex
%.tex: %.md
	kramdown -o latex $< | tail -n +5 | sed 's/\\section{/\\chapter{/; s/\\subsection{/\\section{/; s/\\subsubsection{/\\subsection{/; s/\\paragraph{/\\subsubsection{/; s/\\subparagraph{/\\paragraph{/;'> $@

$(CONTENT_TEX):

$(BUILD)/_template/%.tex: template/%.tex.template
	mkdir -p $(BUILD)/_template
	cp $< $@

$(PDFOUT)a4.pdf:
$(PDFOUT)a5.pdf:
$(PDFOUT)a5-booklet_a4.pdf:
$(PDFOUT)a5-16let_a4.pdf:
$(PDFOUT)a6.pdf:
$(PDFOUT)a6-booklet_a5.pdf:
$(PDFOUT)a6-16let_a5.pdf:
$(PDFOUT)a6-20let_a5.pdf:
$(PDFOUT)a6-20let_a5-doublepages_a4.pdf:
$(PDFOUT)a6-16let_a5-doublepages_a4.pdf:

$(PDFOUT)%.pdf: $(BUILD)/_template/%.tex $(CONTENT_TEX)
	mkdir -p $(BUILD)/$*
	cp $< $(BUILD)/$*
	rm -f $(BUILD)/$*/$(SRC)
	ln -s ../../$(SRC) $(BUILD)/$*
	cd $(BUILD)/$* && latexmk -out2dir=../../$(PDFOUT) $* 

$(PDFOUT)%-booklet_a4.pdf: %-booklet_a4.tex $(PDFOUT)%.pdf
$(PDFOUT)%-booklet_a5.pdf: %-booklet_a5.tex $(PDFOUT)%.pdf
$(PDFOUT)%-16let_a4.pdf: %-16let_a4.tex $(PDFOUT)%.pdf
$(PDFOUT)%-16let_a5.pdf: %-16let_a5.tex $(PDFOUT)%.pdf
$(PDFOUT)%-doublepages_a4.pdf: %-doublepages_a4.tex $(PDFOUT)%.pdf

.PRECIOUS: %-doublepages_a4.tex
$(BUILD)/_template/%-doublepages_a4.tex: template/doublepages.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a4/;s~SOURCE~$(PDFOUT)$*~' > $@

.PRECIOUS: %-booklet_a4.tex
$(BUILD)/_template/%-booklet_a4.tex: template/booklet.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a4/;s~SOURCE~$(PDFOUT)$*~' > $@
.PRECIOUS: %-booklet_a5.tex
$(BUILD)/_template/%-booklet_a5.tex: template/booklet.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a5/;s~SOURCE~$(PDFOUT)$*~' > $@

.PRECIOUS: %-16let_a4.tex
$(BUILD)/_template/%-16let_a4.tex: template/n-let.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a4/;s~SOURCE~$(PDFOUT)$*~;s/SIGNATURE/16/' > $@
.PRECIOUS: %-16let_a5.tex
$(BUILD)/_template/%-16let_a5.tex: template/n-let.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a5/;s~SOURCE~$(PDFOUT)$*~;s/SIGNATURE/16/' > $@

.PRECIOUS: %-16let_a4.tex
$(BUILD)/_template/%-20let_a4.tex: template/n-let.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a4/;s~SOURCE~$(PDFOUT)$*~;s/SIGNATURE/20/' > $@
.PRECIOUS: %-16let_a5.tex
$(BUILD)/_template/%-20let_a5.tex: template/n-let.tex.transform $(PDFOUT)%.pdf
	mkdir -p $(BUILD)/_template/
	cat $< | sed 's/FORMAT/a5/;s~SOURCE~$(PDFOUT)$*~;s/SIGNATURE/20/' > $@



clean:
	latexmk -c
	rm -f *.maf
	rm -f *.mtc
	rm -f *.mtc?
	rm -f *.ptc?
	rm -fr $(BUILD)/
dist-clean: clean
	latexmk -C
	@# remove generated tex file
	rm -f *-booklet_a?.tex
	rm -f *-??let_a?.tex
	rm -f *-doublepages_a?.tex
