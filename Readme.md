# LoFreq Variant Caller v1.0

## What does this app do?
This app calls variants (SNPs) using [LoFreq-Star (also known as LoFreq* or LoFreq version 2)](https://csb5.github.io/lofreq/), which is a fast and sensitive variant-caller for inferring single-nucleotide variants (SNVs) from high-throughput sequencing data.

## What are typical use cases for this app?
Use this app to robustly call low-frequency variants in next-generation sequencing data-sets.

## What data are required for this app to run?
This app requires:
- Coordinate-sorted mappings in BAM format (`*.bam`). It is strongly suggested that the BAM file has undergone GATK indel realignment and base quality score recalibration.
- Reference genome sequence (build 37) in gzipped fasta format (`*.fasta.gz`, `*.fa.gz`)
- Bed file (optional). If provided, ensure there are no overlapping regions as any variants found within multiple regions will be called multiple times.

Parameters (default)
- --call-indels (True) - to call indels 
- advanced options (optional) - A string containing further command line arguments that can be parsed to lofreq

NB this app currently supports build 37 only.

## How does this app work?
LoFreq has some preset defaults to filter variants. These filters revolve around variant qualities (which are converted p-values) which are (by default) based on Bonferroni correction and a significance threshold of 0.01.
There is also a strandbias filter (variants are filtered if their SB pvalue is below the threshold (> 0.001) AND 85% of variant bases are on one strand (toggled with --sb-no-compound)).

1. The app uses sambamba (v0.5.4) to index the BAM file.
2. To utilise multiple processors this app runs 'lofreq call-parallel' (lofreq v2.1.2), adding the bedfile,--call-indels parameter and any advanced options to the command as required. 
  - However, specifying specific filtering arguments using the advanced options may not work (this is untested) and is not reccomended by the LoFreq developers.

For more information, consult the [LoFreq website](http://csb5.github.io/lofreq/) or for filtering options run `lofreq filter` on the command line.

## What does this app output?
This app outputs a VCF file (`*.vcf`) to `/output`.

