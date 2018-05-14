#!/usr/bin/sh
#$
#qsub -v WD=$(pwd) -t 1-61 run_collapser_batch.sh  
#PBS -o trimming/flexbar.log
#PBS -j oe
#PBS -S /bin/bash
#PBS -l nodes=1:ppn=1


#study=GSE89667
study=GSE84779
species=homo_sapiens
wdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}

cd $wdir;

sample=`awk "NR==$SLURM_ARRAY_TASK_ID" SRR_Acc_List.txt;`
myid=$(grep ${sample} config.txt | awk '{print $2}');
#study=$(pwd|awk -F "/" '{print $(NF)}');
#species=$(pwd|awk -F "/" '{print $(NF-1)}');

fastq=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/flexbar/${sample}_flexbar.fastq.gz;
outdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/collapser

mkdir -p $outdir
cd $outdir;

gunzip -c $fastq | /home/users/jmx/local/bin/fastx_collapser -Q 33 -o ${outdir}/${sample}_collapsed.fa
sed "s/>/>${myid}_/;s/-/_x/" "${outdir}/${sample}_collapsed.fa" > ${outdir}/${sample}_collapsed_mdformat.fa


