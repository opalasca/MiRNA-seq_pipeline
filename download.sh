#/bin/bash

module load sratoolkit

mkdir -p fastq
sed -i -e '$a\' SRR_Acc_List.txt  # adds newline character at end of file (otherwise not reading last sample)
while read sample; do
	if [ ! -f fastq/${sample}.fastq.gz ]; then
		echo "Downloading sample $sample"
	        fastq-dump --outdir fastq/ --gzip $sample
	fi
done < SRR_Acc_List.txt
