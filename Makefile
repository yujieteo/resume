FILE = yujieteo_resume

LATEXMK = latexmk
LATEXMK_FLAGS = -pdf -interaction=nonstopmode -halt-on-error

all: $(FILE).pdf

$(FILE).pdf: $(FILE).tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(FILE).tex

clean:
	$(LATEXMK) -c
	rm -f $(FILE).bbl $(FILE).run.xml $(FILE).synctex.gz

cleanall:
	$(LATEXMK) -C
	rm -f $(FILE).bbl $(FILE).run.xml

open:
	open $(FILE).pdf

.PHONY: all clean cleanall open