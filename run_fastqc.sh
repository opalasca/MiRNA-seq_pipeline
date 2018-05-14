#!/bin/bash
module load FastQC
mkdir -p results/fastqc
while read sample; do
        file=fastq/${sample}.fastq.gz
        fastqc -o results/fastqc $file
done < SRR_Acc_List.txt
