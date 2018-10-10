# LoFreq Variant Caller v1.0

## What does this app do?
This app calls variants (SNPs) using [LoFreq-Star (also known as LoFreq* or LoFreq version 2)](https://csb5.github.io/lofreq/), which is a fast and sensitive variant-caller for inferring single-nucleotide variants (SNVs) from high-throughput sequencing data.

## What are typical use cases for this app?
Use this app to robustly call low-frequency variants in next-generation sequencing data-sets.

## What data are required for this app to run?
This app requires:
- Coordinate-sorted mappings in BAM format (`*.bam`). It is strongly suggested that the BAM file has undergone GATK indel realignment and base quality score recalibration.
- Reference genome sequence in gzipped fasta format (`*.fasta.gz`, `*.fa.gz`)
- Bed file (optional)

Parameters (default)
- --call-indels (True) - to call indels 
- advanced options (optional) - A string containing further command line arguments that can be parsed to lofreq

## How does this app work?
1. The app uses sambamba (v0.5.4) to index the BAM file.
2. To utilise multiple processors this app runs 'lofreq call-parallel' (lofreq v2.1.2), adding the bedfile,--call-indels parameter and any advanced options to the command as required. 

For more information, consult the [LoFreq website](http://csb5.github.io/lofreq/)

## What does this app output?
This app outputs a VCF file (`*.vcf`) to `/output`.

