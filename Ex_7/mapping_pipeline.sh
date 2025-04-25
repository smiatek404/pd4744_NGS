#!/bin/bash

source ~/.bashrc

REF="genome_index/Ecoli_K12.fasta"
READS_DIR="trimmed_reads"
OUTPUT_DIR="bam_outputs"
mkdir -p "$OUTPUT_DIR"

echo "Konwersja pliku SAM na BAM..."
samtools view -S -b Ecoli_rep1.sam > "$OUTPUT_DIR/Ecoli_rep1.bam"

echo "Sortowanie BAM..."
samtools sort "$OUTPUT_DIR/Ecoli_rep1.bam" -o "$OUTPUT_DIR/Ecoli_rep1_sorted.bam"

echo "Tworzenie indeksu BAM..."
samtools index "$OUTPUT_DIR/Ecoli_rep1_sorted.bam"

echo "Rozmiary plików:"
du -h Ecoli_rep1.sam "$OUTPUT_DIR/Ecoli_rep1.bam" "$OUTPUT_DIR/Ecoli_rep1_sorted.bam"


for SRR in SRR25629154 SRR25629153
do
    echo "Mapowanie $SRR..."
    bwa mem "$REF" "$READS_DIR/${SRR}_1_trimmed.fastq.gz" "$READS_DIR/${SRR}_2_trimmed.fastq.gz" > "$OUTPUT_DIR/${SRR}.sam"

    echo "     Konwersja do BAM..."
    samtools view -S -b "$OUTPUT_DIR/${SRR}.sam" > "$OUTPUT_DIR/${SRR}.bam"

    echo "     Naprawa sparowanych końców..."
    samtools fixmate -m "$OUTPUT_DIR/${SRR}.bam" "$OUTPUT_DIR/${SRR}_fixmate.bam"

    echo "     Sortowanie naprawionych końców..."
    samtools sort "$OUTPUT_DIR/${SRR}_fixmate.bam" -o "$OUTPUT_DIR/${SRR}_fixmate_sorted.bam"

    echo "     Indeksowanie sortowanych końców..."
    samtools index "$OUTPUT_DIR/${SRR}_fixmate_sorted.bam"

    echo "     Usuwanie duplikatów..."
    samtools markdup -r "$OUTPUT_DIR/${SRR}_fixmate_sorted.bam" "$OUTPUT_DIR/${SRR}_dedup.bam"

    echo "     Indeksowanie pliku bez duplikatów..."
    samtools index "$OUTPUT_DIR/${SRR}_dedup.bam"
done

echo "Gotowe!"

