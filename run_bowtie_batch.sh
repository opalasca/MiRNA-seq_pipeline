#!/usr/bin/sh
#$
#n=`wc -l /home/projects/cpr/anigen/data/IBD_public_data/homo_sapiens/GSE89667/SRR_Acc_List.txt | awk '{print $1}'`
#qsub -v WD=$(pwd) -t 1-37 run_bowtie_batch.sh  
#PBS -o mapping/bowtie.log
#PBS -j oe
#PBS -S /bin/bash
#PBS -l nodes=1:ppn=16

module load mirdeep
module load bowtie

study=GSE89667
species=homo_sapiens
genome_version=Gencode_release_27
ref=GRCh38.primary_assembly.genome

wdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}
cd $wdir
sample=`awk "NR==$SLURM_ARRAY_TASK_ID" SRR_Acc_List.txt;`

ref_file=/home/projects/cpr/anigen/data/genomes/${species}/${genome_version}/${ref}.fa
gidxdir=/home/projects/cpr/anigen/data/genome_indexes/${species}/bowtie/${ref}

#fastqgz=${wdir}/results/flexbar/${sample}_flexbar.fastq.gz
fa=${wdir}/results/collapser/${sample}_collapsed_mdformat.fa
#gunzip $fastqgz

outdir=$wdir/results/mapping
nThreads="4";

mkdir -p $outdir
chmod -R g+r $outdir
chmod -R g+w $outdir
cd $outdir;

#bowtie -S -p 1 -n 0 -e 80 -l 18 -a -m 5 --best --strata \
#bowtie -n 1 -l 8 -a --best --strata \
#bowtie -S -p 1 -v 1 -a -m 8 -f --best --strata \

bowtie -S -p 1 -n 1 -l 22 -e 120 -a -m 8 -f --best --strata \
	--al ${outdir}/${sample}.alignedReads.fa \
	--un ${outdir}/${sample}.unalignedRead.fa \
	$gidxdir \
	$fa \
	${outdir}/${sample}.aligned.sam >${outdir}/${sample}_stats.txt

echo "bowtie finished for $sample"
#gzip ${wdir}/results/flexbar/${sample}_flexbar.fastq
#echo "bowtie finished for $sample"

bwa_sam_converter.pl -i ${sample}.aligned.sam -a ${sample}_aligned.arf
echo "converted to arf format"
