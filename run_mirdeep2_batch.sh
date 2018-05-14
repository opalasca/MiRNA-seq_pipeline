#!/usr/bin/sh
#$
#qsub -v WD=$(pwd) -q fastlane run_mirdeep2_batch.sh  
#PBS -o trimming/flexbar.log
#PBS -j oe
#PBS -S /bin/bash
#PBS -l nodes=1:ppn=16,mem=62g


study=GSE89667
species=homo_sapiens
version=Gencode_release_27
ref=GRCh38.primary_assembly.genome
ref_file=/home/projects/cpr/anigen/data/genomes/${species}/${version}/${ref}_sp_rem.fa
wdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}
cd $wdir;

cdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/collapser
mdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/mapping

allreads=${cdir}/all_reads_collapsed.fa
allreads_mapped=${mdir}/all_reads_mapped.arf
allreads_filtered=${cdir}/all_reads_collapsed_filtered_by_length.fa

mirbase=/home/projects/cpr/anigen/data/miRBase22

outdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/mirdeep2

mkdir -p $outdir
cd $outdir;

module load mirdeep
module load bowtie

miRDeep2.pl $allreads_filtered $ref_file $allreads_mapped ${mirbase}/hsa_mature.fa none ${mirbase}/hsa_prec.fa -t Human 2>report.log

