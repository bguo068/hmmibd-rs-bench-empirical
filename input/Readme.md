# MalariaGEN Pf VCF Data Download Guide

## Description

For details about the dataset, please refer to the official resource page:
[MalariaGEN Resource 34](https://www.malariagen.net/resource/34/)

## VCF Data FTP URL

The VCF data can be accessed and downloaded from the following FTP server:
[ftp://ngs.sanger.ac.uk/production/malaria/Resource/34/Pf7_vcf/](ftp://
ngs.sanger.ac.uk/production/malaria/Resource/34/Pf7_vcf/)

## Software Installation

To download the data, you need to have `lftp` installed. We recommend using
`mamba` for installation due to its speed and efficiency.

```sh
mamba install lftp
```

## Data Download Instructions

### Step 1: Login
Open your terminal and log in to the FTP server using `lftp`:
```sh
lftp ftp://ngs.sanger.ac.uk/production/malaria/Resource/34/Pf7_vcf/
```

### Step 2: Download Data
Once logged in, navigate to the parent directory and start the download using
the `mirror` command:
```lftp
lftp> cd ..
lftp> mirror Pf7_vcf
```

This will download `Pf7_vcf` directory and its contents to your current local directory.

### Step 3: Check File Sizes
You can check the sizes of the downloaded files to ensure they were fully
downloaded. Below is a sample list of the files with their respective sizes.

```sh
lftp ngs.sanger.ac.uk:/production/malaria/Resource/34/Pf7_vcf> ls -lh
# -r-xr--r--   1 proftpd  proftpd     33.8G Jan  4  2023 Pf3D7_01_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      2.2k Jan  4  2023 Pf3D7_01_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     45.4G Jan  4  2023 Pf3D7_02_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      2.4k Jan  4  2023 Pf3D7_02_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     51.1G Jan  4  2023 Pf3D7_03_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      2.9k Jan  4  2023 Pf3D7_03_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     60.4G Jan  4  2023 Pf3D7_04_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      2.8k Jan  4  2023 Pf3D7_04_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     60.6G Jan  4  2023 Pf3D7_05_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      2.3k Jan  4  2023 Pf3D7_05_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     65.6G Jan  4  2023 Pf3D7_06_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      2.8k Jan  4  2023 Pf3D7_06_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     71.2G Jan  4  2023 Pf3D7_07_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      3.5k Jan  4  2023 Pf3D7_07_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     73.6G Jan  4  2023 Pf3D7_08_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      3.4k Jan  4  2023 Pf3D7_08_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     78.6G Jan  4  2023 Pf3D7_09_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      4.0k Jan  4  2023 Pf3D7_09_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     80.5G Jan  4  2023 Pf3D7_10_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      4.3k Jan  4  2023 Pf3D7_10_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd     97.3G Jan  5  2023 Pf3D7_11_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      3.9k Jan  5  2023 Pf3D7_11_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd    110.5G Jan  5  2023 Pf3D7_12_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      4.3k Jan  5  2023 Pf3D7_12_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd    137.0G Jan  5  2023 Pf3D7_13_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      5.3k Jan  5  2023 Pf3D7_13_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd    158.1G Jan  5  2023 Pf3D7_14_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd      4.7k Jan  5  2023 Pf3D7_14_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd    667.1M Jan  5  2023 Pf3D7_API_v3.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd       153 Jan  5  2023 Pf3D7_API_v3.pf7.vcf.gz.tbi
# -r-xr--r--   1 proftpd  proftpd    162.8M Jan  5  2023 Pf_M76611.pf7.vcf.gz
# -r-xr--r--   1 proftpd  proftpd       115 Jan  5  2023 Pf_M76611.pf7.vcf.gz.tbi
```

By following these steps, you should be able to successfully download all
required VCF files from the MalariaGEN Resource 34. If you encounter any issues,
please consult the `lftp` documentation or reach out for further assistance.


#  VCF pre-filtering

See script:  `pre_filt_bcf.sh`

