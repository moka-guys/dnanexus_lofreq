#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

#
# Fetch and index genome
#
mark-section "fetching and uncompressing reference genome"
# create directory for reference genome, un-package reference genome
mkdir genome
dx cat "$genome_fastagz" | tar zxvf - -C genome  
# => genome/<ref>, genome/<ref>.ann, genome/<ref>.bwt, etc.

# rename genome files to grch37 so that the VCF header states the reference to be grch37.fa, which then allows Ingenuity to accept the VCFs (otherwise VCF header would have reference as genome.fa which Ingenuity won't accept)
mv genome/*.fa genome/grch37.fa
mv genome/*.fa.fai genome/grch37.fa.fai

# mv genome.dict grch37.dict
# specify the reference file to variable
genome_file=genome/grch37.fa

#mark-section "indexing reference genome"
#samtools faidx "$genome_file"

#
# Fetch and index mappings
#
mark-section "fetching mappings"
# download all inputs
dx-download-all-inputs --except genome_fastagz

mark-section "indexing mappings"
# index the bamfile using sambamba
sambamba index -t `nproc` "$sorted_bam_path"

mark-section "building lofreq command"
# add non-optional arguments to opts string. use nproc to get # threads. specify the reference file and any advanced options specified.
opts="--pp-threads `nproc` --ref $genome_file $advanced_options --out output.vcf"

# check if call indels flag is True and add to command
if [[ "$call_indels" == true ]]; then
  opts="$opts --call-indels "
fi

# check if bedfile is provided and add to command
if [ "$bedfile" != "" ]; then
  opts="$opts --bed $bedfile_path "
fi

#
# Run lofreq
#
mark-section "running lofreq"
# call lofreq utilising multiple cores and using the arguments specified above
lofreq call-parallel $opts "$sorted_bam_path"

#
# Upload results
#
mark-section "uploading results"

# make output folders
mkdir -p ./out/variants_vcf/output 

# move vcf to the output folder and rename
mv output.vcf ./out/variants_vcf/output/"$sorted_bam_prefix".lofreq.vcf

# upload all outputs
dx-upload-all-outputs --parallel
mark-success
