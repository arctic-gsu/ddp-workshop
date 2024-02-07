#!/bin/bash
#SBATCH --job-name=sh_exp
#SBATCH -w acidsgcn002,acidsgcn003
#SBATCH --account=univ1s16
#SBATCH --partition=qGPU24
#SBATCH --nodes=2
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

export CUDA_LAUNCH_BLOCKING=1

rsync -av --exclude 'errors/' --exclude 'outputs/' /home/users/sshrestha8/ARCTIC/ddp_workshop .

cd ddp_workshop

module load singularity
srun singularity run --nv -B /etc/libibverbs.d -B /scratch/$SLURM_JOB_ID/ddp_workshop:/scratch/$SLURM_JOB_ID/ddp_workshop /sysapps/singularity_images/pytorch:23.11-py3-arctic.sif /scratch/$SLURM_JOB_ID/ddp_workshop/run_multinode.sh 50 10
