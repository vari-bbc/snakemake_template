#!/bin/bash
#SBATCH --export=NONE
#SBATCH -J snake_workflow
#SBATCH -o snake_workflow.o
#SBATCH -e snake_workflow.e
#SBATCH --ntasks 1
#SBATCH --time 120:00:00
#SBATCH --mem=8G
#SBATCH --partition=long


module load bbc2/snakemake/snakemake-9.13.2
module load bbc2/apptainer/apptainer-v1.4.3-1.el8

# make logs dir if it does not exist already. 
logs_dir="logs/"
[[ -d $logs_dir ]] || mkdir -p $logs_dir


snakemake -p --profile 'profile/generic_slurm/'
