## Agenda:
1. slides [10 - 10:30] <br>
2. create virtual env [10:30 - 10:45]<br>
3. Handson: <br>
    a. Start 1_Single_node_Single_gpu.ipynb,copy to python file 1_Single_node_Single_gpu.py, and run it though terminal [10:45 - 11:15]<br>
    b. Slides 6-13 [11:30 - 12:00]<br>
    c. Start 2_Single_node_Multi_gpu_torchrun.py [12:00 - 12:15]<br>
    d. Start 3_Multi_node_Multi_gpu_torchrun.py [12:15 - 12:30]<br>
    e. Write a basic slurm script, run a basic python file test_sbatch.py [12:30 - 12:50]<br>
    f. Start 2_Single_node_Multi_gpu_torchrun.py with slurm [1:00 - 1:15]<br>
    g. Start 3_Multi_node_Multi_gpu_torchrun.py with slurm [1:15 - 1:30]<br>
    h. Questionaire [1:30 - 2:00]<br>

## Create virtual environment
```
cd ~
module load python
mkdir -p /userapp/virtualenv/workshop/{username}/
python3 -m venv /userapp/virtualenv/workshop/{username}/
python3 -m venv /userapp/virtualenv/workshop/{username}/
source /userapp/virtualenv/workshop/{username}/bin/activate
```
install libraries
```
pip install torch
pip install jupyter notebook
pip freeze > requirements.txt
pip install -r requirements.txt
```

## Start code for single node single gpu
Run in jupyter notebook 1_Single_node_Single_gpu.ipynb with your virtual environment

```
output
[GPU0] Epoch 0 | Batchsize: 32 | Steps: 64
Epoch 0 | Training checkpoint saved at checkpoint.pt
[GPU0] Epoch 1 | Batchsize: 32 | Steps: 64
[GPU0] Epoch 2 | Batchsize: 32 | Steps: 64
[GPU0] Epoch 3 | Batchsize: 32 | Steps: 64
```
Copy to python file 1_Single_node_Single_gpu.py, and run it though terminal:

start srun in terminal for gpu cuda
```
srun -p qGPU24 -A univ1s16 --nodes=1 --ntasks-per-node=1 --gres=gpu:2 --time=04:00:00 --mem=100G -w acidsgcn003 --pty bash
```

output:
```
srun: job **** queued and waiting for resources
srun: job **** has been allocated resources
```

run python:
```
python 1_Single_node_Single_gpu.py
```
output
```
[GPU0] Epoch 0 | Batchsize: 32 | Steps: 64
Epoch 0 | Training checkpoint saved at checkpoint.pt
[GPU0] Epoch 1 | Batchsize: 32 | Steps: 64
[GPU0] Epoch 2 | Batchsize: 32 | Steps: 64
[GPU0] Epoch 3 | Batchsize: 32 | Steps: 64
```

## Start code for single node multi gpu
run it through terminal
```
torchrun --standalone --nproc_per_node=gpu 2_Single_node_Multi_gpu_torchrun.py 50 10
```
output
```
[GPU0] Epoch 1 | Batchsize: 32 | Steps: 32
[GPU0] Epoch 2 | Batchsize: 32 | Steps: 32
[GPU1] Epoch 2 | Batchsize: 32 | Steps: 32
[GPU1] Epoch 3 | Batchsize: 32 | Steps: 32
```

## Start multi node multi gpu
start another login nodes
start srun in that node
```
srun -p qGPU24 -A univ1s16 --nodes=1 --ntasks-per-node=1 --gres=gpu:2 --time=04:00:00 --mem=100G -w acidsgcn003 --pty bash
srun -p qGPU24 -A univ1s16 --nodes=1 --ntasks-per-node=1 --gres=gpu:2 --time=04:00:00 --mem=100G -w acidsgcn002 --pty bash
```

in node1:
```
torchrun --nproc_per_node=2 --nnodes=2 --node_rank=0 --rdzv_id=456 --rdzv_backend=c10d --rdzv_endpoint=acidsgcn002:45346 5.Multi_gpu_torchrun.py 50 10
```
in node2:
```
torchrun --nproc_per_node=2 --nnodes=2 --node_rank=1 --rdzv_id=456 --rdzv_backend=c10d --rdzv_endpoint=acidsgcn002:45346 5.Multi_gpu_torchrun.py 50 10
```

output from node1 terminal:
```
[GPU0] Epoch 33 | Batchsize: 32 | Steps: 16
[GPU1] Epoch 33 | Batchsize: 32 | Steps: 16
[GPU0] Epoch 34 | Batchsize: 32 | Steps: 16
[GPU1] Epoch 34 | Batchsize: 32 | Steps: 16
```
output from node2 terminal
```
[GPU2] Epoch 22 | Batchsize: 32 | Steps: 16
[GPU3] Epoch 22 | Batchsize: 32 | Steps: 16
[GPU2] Epoch 23 | Batchsize: 32 | Steps: 16
[GPU3] Epoch 23 | Batchsize: 32 | Steps: 16
```
## Write a basic slurm script
Run a basic python file jobsubmit.sh to run 1_Single_node_Single_gpu.py

commands to srun sbatch
```
sbatch jobsubmit.sh
```
check if your job is running or not
```
squeue -u sshrestha8
```
output
```
4397800    qGPU24   sh_exp sshresth  R       0:02      2 acidsgcn002
```
see output logs are with names output_[job_id].sh under outputs folder
if you get any errors, error logs are with names error_[job_id].sh under errors folder

## Start 3_Multi_node_Multi_gpu_torchrun.py with slurm
run jobscript for multinode:
```
sbatch jobsubmit_multinode.sh
```

check if job is running:
```
squeue -u sshrestha8
```
notice [002-003], 2 nodes are being used
```
4397831    qGPU24   sh_exp sshresth  R       0:02      2 acidsgcn[002-003]
```

you should encounter an error:
error_[job_id]

go into that error file and find out error

fix and run again, you should be able to see below statement if your code ran successfully
```
Local worker group finished (WorkerState.SUCCEEDED). Waiting 300 seconds for other agents to finish
```


