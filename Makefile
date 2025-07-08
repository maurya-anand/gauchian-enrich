.PHONY: all install transvar clean help

help:
	@printf "Invalid target\nUsage:\nmake install\nmake transvar VAR=DHODH:p.G152R\nThe protein variant (p.change) should be in HGVS format.\n"

.DEFAULT_GOAL := help

REF_DIR := $(PWD)/ref

GENOME_FA_GZ = GRCh38.primary_assembly.genome.fa.gz

GENOME_FA = GRCh38.primary_assembly.genome.fa

HG38_FA = hg38.fa

URL = https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/$(GENOME_FA_GZ)

all: install transvar

install: $(REF_DIR)/$(HG38_FA)

$(REF_DIR)/$(HG38_FA):
	@mkdir -p $(REF_DIR)
	@wget -O $(REF_DIR)/$(GENOME_FA_GZ) $(URL)
	@gunzip $(REF_DIR)/$(GENOME_FA_GZ)
	@mv $(REF_DIR)/$(GENOME_FA) $(REF_DIR)/$(HG38_FA)
	@docker run -v $(REF_DIR):/ref zhouwanding/transvar:latest samtools faidx /ref/$(HG38_FA)

transvar: install
	@if [ -z "$(VAR)" ]; then \
		$(MAKE) help; \
	else \
		docker run -v $(REF_DIR):/ref zhouwanding/transvar:latest transvar panno -i $(VAR) --refversion hg38 --refseq --gseq --longest --reference /ref/$(HG38_FA); \
	fi

clean:
	rm -rf $(REF_DIR)