#!/usr/bin/sh
study=GSE89667
species=homo_sapiens
wdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}
cdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/collapser
mdir=/home/projects/cpr/anigen/data/IBD_public_data/${species}/${study}/results/mapping

allreads=${cdir}/all_reads_collapsed.fa
allreads_mapped=${mdir}/all_reads_mapped.arf
allreads_filtered=${cdir}/all_reads_collapsed_filtered_by_length.fa

echo >$allreads;
echo >$allreads_mapped;
while read sample; do
        collapsed=${cdir}/${sample}_collapsed_mdformat.fa
        mapped=${mdir}/${sample}_aligned.arf
        cat $collapsed >> $allreads
        cat $mapped >> $allreads_mapped
done < ${wdir}/SRR_Acc_List.txt

allreads_filtered=${cdir}/all_reads_collapsed_filtered_by_length.fa
awk '{if ($0!~/>/ && length($0)>16) {print a; print;} else (a=$0);}' $allreads > $allreads_filtered
