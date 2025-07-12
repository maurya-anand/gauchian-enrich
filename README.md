# Gauchian-enrich

This repository contains a command-line utility to annotate the .tsv file output from [Illumina/Gauchian](https://github.com/Illumina/Gauchian) tool.

## Prerequisites

- Docker

## Setup

```bash
docker pull 
```

## Usage

**Step 1** : Run the [Illumina/Gauchian](https://github.com/Illumina/Gauchian) tool to obtain the `.tsv` and `.json` output.

**Step 2** : Use the `.tsv` ouput file from the previous step as an input to `gauchian_enrich` utility.

```bash
gauchian_enrich <input.tsv> <output.tsv>
```

```bash
gauchian_enrich example/gauchian.output.tsv example/gauchian.enriched.output.tsv 
```

## Example

### Input

| Sample           | is_biallelic(GBAP1-like_variant_exon9-11) | is_carrier(GBAP1-like_variant_exon9-11) | CN(GBA+GBAP1) | deletion_breakpoint_in_GBA | GBAP1-like_variant_exon9-11 | other_unphased_variants |
|-------------------|------------------------------------------|------------------------------------------|---------------|-----------------------------|-----------------------------|--------------------------|
| NA20815.final     | FALSE                                    | TRUE                                     | 4             | N/A                         | L483P/

### Output

| Sample         | is_biallelic(GBAP1-like_variant_exon9-11) | is_carrier(GBAP1-like_variant_exon9-11) | CN(GBA+GBAP1) | deletion_breakpoint_in_GBA | GBAP1-like_variant_exon9-11 | other_unphased_variants | input      | transcript                    | gene | strand | coordinates(gDNA/cDNA/protein)                          | region                   | info                                                                                                                                                                                                                                                                                                                      | CHROM | POS       | REF | ALT |
|----------------|--------------------------------------------|------------------------------------------|----------------|-----------------------------|------------------------------|--------------------------|------------|----------------------------------|------|--------|---------------------------------------------------------|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|------------|-----|-----|
| NA20815.final  | FALSE                                      | TRUE                                     | 4              | N/A                         | L483P/                       | None                     | GBA:L483P | NM_001005742.2 (protein_coding) | GBA  | -      | chr1:g.155235252A>G/c.1448T>C/p.L483P                  | inside_[cds_in_exon_11] | CSQN=Missense;reference_codon=CTG;candidate_codons=CCT,CCG,CCA,CCC;candidate_mnv_variants=chr1:g.155235251_155235252delCAinsAG,chr1:g.155235251_155235252delCAinsTG,chr1:g.155235251_155235252delCAinsGG;dbxref=GeneID:2629,HGNC:HGNC:4177,MIM:606463;aliases=NP_001005742;source=RefSeq | chr1   | 155235252 | A   | G   |

## Reference

Zhou, W., Chen, T., Chong, Z. et al. TransVar: a multilevel variant annotator for precision genomics. Nat Methods 12, 1002–1003 (2015). https://doi.org/10.1038/nmeth.3622
