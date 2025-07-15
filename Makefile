.PHONY: install check-tools install-transvar configure-transvar

ROOT_DIR := $(shell pwd)

check-tools:
	@command -v samtools >/dev/null 2>&1 || { echo "Error: samtools is not installed."; exit 1; }
	@command -v wget >/dev/null 2>&1 || { echo "Error: wget is not installed."; exit 1; }
	@command -v gunzip >/dev/null 2>&1 || { echo "Error: gunzip is not installed."; exit 1; }
	@command -v pip >/dev/null 2>&1 || command -v pip3 >/dev/null 2>&1 || { echo "Error: pip or pip3 is not installed."; exit 1; }
	@perl -MParallel::ForkManager -e 1 >/dev/null 2>&1 || { echo "Error: Perl module Parallel::ForkManager is not installed."; exit 1; }
	@echo "All required tools and modules are installed."

install-transvar:
	@echo "Installing TransVar."
	@$(shell which python) -m pip install transvar
	@echo "TransVar installed successfully."

configure-transvar:
	@echo "Downloading TransVar annotation: hg38."
	@echo "Downloading genome reference: hg38."
	@mkdir -p $(ROOT_DIR)/anno
	@if [ ! -f $(ROOT_DIR)/anno/hg38.fa ]; then \
		wget --no-check-certificate -O $(ROOT_DIR)/anno/hg38.fa.gz https://hgdownload.soe.ucsc.edu/goldenpath/hg38/bigZips/hg38.fa.gz && gunzip $(ROOT_DIR)/anno/hg38.fa.gz; \
	else \
		echo "File hg38.fa already exists. Skipping download."; \
	fi
	@if [ ! -f $(ROOT_DIR)/anno/hg38.fa.fai ]; then \
		samtools faidx $(ROOT_DIR)/anno/hg38.fa; \
	else \
		echo "File hg38.fa.fai already exists. Skipping indexing."; \
	fi
	@if [ -f $(ROOT_DIR)/transvardb/transvardb.tar.gz ]; then \
		tar -xzvf $(ROOT_DIR)/transvardb/transvardb.tar.gz -C $(ROOT_DIR)/anno/; \
	fi
	@echo "[DEFAULT]" > $(ROOT_DIR)/anno/transvar.cfg
	@echo "refversion = hg38" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "[hg38]" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "refseq = $(ROOT_DIR)/anno/hg38.refseq.gff.gz.transvardb" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "ccds = $(ROOT_DIR)/anno/hg38.ccds.txt.transvardb" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "ensembl = $(ROOT_DIR)/anno/hg38.ensembl.gtf.gz.transvardb" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "gencode = $(ROOT_DIR)/anno/hg38.gencode.gtf.gz.transvardb" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "ucsc = $(ROOT_DIR)/anno/hg38.ucsc.txt.gz.transvardb" >> $(ROOT_DIR)/anno/transvar.cfg
	@echo "reference = $(ROOT_DIR)/anno/hg38.fa" >> $(ROOT_DIR)/anno/transvar.cfg
	@TRANSVAR_INSTALL_DIR=$$(python3 -c "import transvar; print(transvar.__path__[0])") && \
	echo "TransVar is located at: $$TRANSVAR_INSTALL_DIR" && \
	mkdir -p $$TRANSVAR_INSTALL_DIR/lib/transvar && \
	cp $(ROOT_DIR)/anno/transvar.cfg ~/.transvar.cfg && \
	echo "TransVar configuration file created successfully." && \
	$$(which transvar) config -k reference -v $(ROOT_DIR)/anno/hg38.fa --refversion hg38
	@chmod a+x $(ROOT_DIR)/bin/gauchian_enrich
		@echo "Setup completed successfully."
		@echo "To use the utility, you can either:"
		@echo "1. Add the following directory to your PATH:"
		@echo "   export PATH=$(ROOT_DIR)/bin:\$$PATH"
		@echo "2. Run the utility directly using its full path:"
		@echo "   $(ROOT_DIR)/bin/gauchian_enrich"

install: check-tools install-transvar configure-transvar