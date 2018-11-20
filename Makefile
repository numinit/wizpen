SPELLBOOK_TEX := spellbook.tex
SPELLBOOK_PDF := spellbook.pdf

WIZPEN_MF := texmf/fonts/source/wizpen/wizpen.mf

all: $(SPELLBOOK_PDF)

clean:
	rm -f $(WIZPEN_MF)
	find texmf -type d -perm /1000 -exec rm -rf {} \; || true
	rm -f *.aux *.log
	rm -f $(SPELLBOOK_PDF)

redo:
	$(MAKE) clean
	$(MAKE) all

.PHONY: all clean redo

$(WIZPEN_MF):
	mkdir -p $(dir $(WIZPEN_MF))
	ruby script/wizpen.rb > $(WIZPEN_MF)

$(SPELLBOOK_PDF): $(SPELLBOOK_TEX) $(WIZPEN_MF)
	TEXMFHOME=texmf pdflatex $(SPELLBOOK_TEX)
