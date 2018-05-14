#!/usr/bin/sh
#$
#qsub -v WD=$(pwd) -q fastlane bowtie_index.sh
#PBS -o mapping/bowtie.log
#PBS -j oe
#PBS -S /bin/bash
#PBS -l nodes=1:ppn=32

#perl -plane 's/\s+.+$//' < GRCh38.primary_assembly.genome.fa > GRCh38.primary_assembly.genome_sp_rem.fa
species=homo_sapiens
version=Gencode_release_27
ref=GRCh38.primary_assembly.genome
ref_file=/home/projects/cpr/anigen/data/genomes/${species}/${version}/${ref}_sp_rem.fa
gidxdir=/home/projects/cpr/anigen/data/genome_indexes/${species}/bowtie

mkdir -p ${gidxdir}
chmod -R 774 ${gidxdir}
cd $gidxdir


module load bowtie
bowtie-build ${ref_file} ${ref}

