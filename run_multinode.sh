#!/bin/sh
OMP_NUM_THREADS=4 NCCL_DEBUG_SUBSYS=COLL NCCL_ASYNC_ERROR_HANDLING=0 NCCL_SOCKET_FAMILY=AF_INET NCCL_DEBUG=ERROR LOGLEVEL=DEBUG   NCCL_P2P_LEVEL=  python3 -m torch.distributed.run --nnodes 2 --nproc_per_node 4  --max_restarts 3  --rdzv_id 1234 --rdzv_backend c10d --rdzv_endpoint acidsgcn002:45346  --log_dir=$1  -r 3  3_Multi_node_Multi_gpu_torchrun.py $2 $3
