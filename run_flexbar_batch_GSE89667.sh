#!/usr/bin/sh
#$
#qsub -v WD=$(pwd) -t 1-37 run_flexbar_batch.sh  
#PBS -o trimming/flexbar.log
#PBS -j oe
#PBS -S /bin/bash
#PBS -l nodes=1:ppn=1

module load flexbar
module load FastQC

study=GSE89667
species=homo_sapiens
wdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}

cd $wdir;
mkdir -p results
mkdir -p results/flexbar
mkdir -p results/fastqc_after

sample=`awk "NR==$SLURM_ARRAY_TASK_ID" SRR_Acc_List.txt;`
#study=$(pwd|awk -F "/" '{print $(NF)}');
#species=$(pwd|awk -F "/" '{print $(NF-1)}');

#Annotation=/home/projects/
#Genome=/home/projects/
#GenomeIndex=

fastq=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/fastq/${sample}.fastq.gz;
outdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/flexbar
fastqcdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/fastqc_after
#adapters=/home/projects/cpr/anigen/data/IBD_public_data/adapters/IlluminatAdapterContamination_t15a.fa
adapters=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/fastq/${sample}_Adapters.fa;

qf=$(zcat ${fastq} | perl -ne 'if($.%4==0){ if(/[KLMNOPQRSTUVWXYZ[\]^_`abcdefghi]/){  print "i1.5"; exit} elsif(/[!"#$%&()*+,-.0123456789:]/){print "i1.8";exit}}')

cd $outdir;

nThreads="16";

time flexbar -r $fastq -a $adapters -q "WIN" -qf ${qf} -qt "25" -m 14 -t ${outdir}/${sample}_flexbar  

gzip ${outdir}/${sample}_flexbar.fastq

fastqc -o ${fastqcdir} ${outdir}/${sample}_flexbar.fastq.gz
