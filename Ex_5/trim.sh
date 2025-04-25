#!/bin/bash


samples=("SRR25629154" "SRR25629153")

for sample in "${samples[@]}"; do
    echo "Przycinanie próbki: $sample"

    trimmomatic PE -threads 4 -phred33 \
      ${sample}_1.fastq.gz ${sample}_2.fastq.gz \
      ${sample}_1_trimmed.fastq.gz /dev/null \
      ${sample}_2_trimmed.fastq.gz /dev/null \
      LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50 \
      &> ${sample}_trimmomatic_stats.txt

    echo "Zakończono: $sample"
    echo "Statystyki zapisano w: ${sample}_trimmomatic_stats.txt"
    echo "--------------------------"
done
