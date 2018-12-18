VERSION := $(file < VERSION)

SPELLBOOK_TEX := spellbook.tex
SPELLBOOK_PDF := spellbook.pdf

EXAMPLE_TEX := example.tex
EXAMPLE_PDF := example.pdf

WIZPEN_MF := texmf/fonts/source/wizpen/wizpen.mf

WIZPEN_PFB := fonts/wizpen.pfb
WIZPEN_TTF := fonts/wizpen.ttf
WIZPEN_OTF := fonts/wizpen.otf

all: $(EXAMPLE_PDF)

spellbook: $(SPELLBOOK_PDF)

clean:
	rm -f $(WIZPEN_MF)
	find texmf -type d -perm /1000 -exec rm -rf {} \; || true
	rm -f *.aux *.log
	rm -f *.pdf

redo:
	$(MAKE) clean
	$(MAKE) all

spellbook-redo:
	$(MAKE) clean
	$(MAKE) spellbook

font: $(WIZPEN_TTF) $(WIZPEN_OTF)

font-clean:
	rm -f fonts/*

.PHONY: all spellbook clean redo spellbook-redo font font-clean

$(WIZPEN_MF):
	mkdir -p $(dir $(WIZPEN_MF))
	ruby script/wizpen.rb $(VERSION) > $(WIZPEN_MF)

$(WIZPEN_PFB): $(WIZPEN_MF)
	ln -s ../$^ fonts/$(notdir $^)
	cd fonts && mf2pt1 $(notdir $^)

$(WIZPEN_TTF): $(WIZPEN_PFB)
	./script/tfm2ttf.pe $^

$(WIZPEN_OTF): $(WIZPEN_PFB)
	./script/tfm2otf.pe $^

$(EXAMPLE_PDF): $(EXAMPLE_TEX) $(WIZPEN_MF)
	TEXMFHOME=texmf lualatex $(EXAMPLE_TEX)

$(SPELLBOOK_PDF): $(SPELLBOOK_TEX) $(WIZPEN_MF)
	TEXMFHOME=texmf lualatex $(SPELLBOOK_TEX)
