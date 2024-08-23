#! /usr/bin/env bash
set -eEuo pipefail

if [ ! -e monoclonal_samples.txt ]; then
  mkdir -p meta
  cd meta
  wget https://www.malariagen.net/wp-content/uploads/2023/11/Pf7_fws.txt 
  cat Pf7_fws.txt | awk 'NR>1 && $2>0.95{print $1}' > monoclonal_samples.txt
fi

bcftools concat \
  Pf7_vcf/Pf3D7_0{1..9}_v3.pf7.vcf.gz Pf7_vcf/Pf3D7_1{0..4}_v3.pf7.vcf.gz \
  --threads 20 -Ou  | \
  bcftools view -f PASS -i 'F_MISSING < 0.7' -v snps -Ou | \
  bcftools view -q 0.01:minor -Ou | \
  bcftools annotate -x ^FMT/GT,^FMT/AD,^INFO/AN,^INFO/AC,^INFO/AF --threads 15 -Ob -o Pf7_filt.bcf 

# processing time information
# Concatenating Pf3D7_01_v3.pf7.vcf.gz 1720.497856 seconds
# Concatenating Pf3D7_02_v3.pf7.vcf.gz 2119.268130 seconds
# Concatenating Pf3D7_03_v3.pf7.vcf.gz 2364.708051 seconds
# Concatenating Pf3D7_04_v3.pf7.vcf.gz 2970.577094 seconds
# Concatenating Pf3D7_05_v3.pf7.vcf.gz 2444.890459 seconds
# Concatenating Pf3D7_06_v3.pf7.vcf.gz 2977.720974 seconds
# Concatenating Pf3D7_07_v3.pf7.vcf.gz 3299.977394 seconds
# Concatenating Pf3D7_08_v3.pf7.vcf.gz 3382.377916 seconds
# Concatenating Pf3D7_09_v3.pf7.vcf.gz 11806.928286 seconds
# Concatenating Pf3D7_10_v3.pf7.vcf.gz 3662.831340 seconds
# Concatenating Pf3D7_11_v3.pf7.vcf.gz 4110.825870 seconds
# Concatenating Pf3D7_12_v3.pf7.vcf.gz 4894.922048 seconds
# Concatenating Pf3D7_13_v3.pf7.vcf.gz 2747.724467 seconds
# Concatenating Pf3D7_14_v3.pf7.vcf.gz
