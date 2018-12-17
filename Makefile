VERSION := $(file < VERSION)

SPELLBOOK_TEX := spellbook.tex
SPELLBOOK_PDF := spellbook.pdf

EXAMPLE_TEX := example.tex
EXAMPLE_PDF := example.pdf

WIZPEN_MF := texmf/fonts/source/wizpen/wizpen.mf

all: $(EXAMPLE_PDF)

spellbook: $(SPELLBOOK_PDF)

clean:
	rm -f $(WIZPEN_MF)
	find texmf -type d -perm /1000 -exec rm -rf {} \; || true
	rm -f *.aux *.log
	rm -f *.pdf

spellbook-redo:
	$(MAKE) clean
	$(MAKE) spellbook

redo:
	$(MAKE) clean
	$(MAKE) all

.PHONY: all clean redo

$(WIZPEN_MF):
	mkdir -p $(dir $(WIZPEN_MF))
	ruby script/wizpen.rb $(VERSION) > $(WIZPEN_MF)

$(EXAMPLE_PDF): $(EXAMPLE_TEX) $(WIZPEN_MF)
	TEXMFHOME=texmf lualatex $(EXAMPLE_TEX)

$(SPELLBOOK_PDF): $(SPELLBOOK_TEX) $(WIZPEN_MF)
	TEXMFHOME=texmf lualatex $(SPELLBOOK_TEX)
