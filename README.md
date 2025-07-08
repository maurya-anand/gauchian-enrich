# transvar-enrich

This repository contains a Makefile that simplifies the setup and execution of TransVar for reverse annotation of protein variants (p.change to g.change).

## Prerequisites

- Docker
- make

## Setup

To download the necessary reference genome and prepare it for TransVar, run:

```bash
make install
```

This will download the GRCh38 reference genome, place it in the `ref` directory, and index it.

## Usage

To perform a protein-level reverse annotation, run the `transvar` target, passing the protein variant (p.change) in HGVS format as input.

For example:

```bash
make transvar VAR=DHODH:p.G152R
```

```bash
make transvar VAR=NM_006218.2:p.E545K
```

## Example

### Input

```bash
make transvar VAR=DHODH:p.G152R
```

### Output

| input         | transcript                      | gene  | strand | coordinates(gDNA/cDNA/protein)      | region                 | info                                                                                                                                                                                                                                                                                       | CHROM | POS      | REF | ALT |
|---------------|---------------------------------|-------|--------|-------------------------------------|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|----------|-----|-----|
| DHODH:p.G152R | NM_001361.4 (protein_coding)    | DHODH | +      | chr16:g.72017043G>A/c.454G>A/p.G152R | inside_[cds_in_exon_4] | CSQN=Missense;reference_codon=GGG;candidate_codons=AGG,AGA,CGA,CGC,CGG,CGT;candidate_snv_variants=chr16:g.72017043G>C;candidate_mnv_variants=chr16:g.72017043_72017045delGGGinsAGA,chr16:g.72017043_72017045delGGGinsCGA,chr16:g.72017043_72017045delGGGinsCGC,chr16:g.72017043_72017045delGGGinsCGT;dbxref=GeneID:1723,HGNC:HGNC:2867,MIM:126064;aliases=NP_001352;source=RefSeq | chr16 | 72017043 | G   | A   |

## Cleaning up

To remove the downloaded reference files, run:

```bash
make clean
```


## Reference
Zhou, W., Chen, T., Chong, Z. et al. TransVar: a multilevel variant annotator for precision genomics. Nat Methods 12, 1002–1003 (2015). https://doi.org/10.1038/nmeth.3622