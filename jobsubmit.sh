#!/bin/bash
#SBATCH --job-name=sh_exp
#SBATCH -w acidsgcn002
#SBATCH --account=univ1s16
#SBATCH --partition=qGPU24
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --mem=32G
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --gpus-per-task=2
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sshrestha8@student.gsu.edu
#SBATCH --output=outputs/output_%j
#SBATCH --error=errors/error_%j


cd /scratch
mkdir -p $SLURM_JOB_ID
cd $SLURM_JOB_ID

rsync -av --exclude 'errors/' --exclude 'outputs/' /home/users/sshrestha8/ARCTIC/ddp_workshop .

cd ddp_workshop

python 1_Single_node_Single_gpu.py
