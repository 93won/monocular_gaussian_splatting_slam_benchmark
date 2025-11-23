<!--
@file      README.md
@brief     MonoGS Docker setup guide and documentation
@author    Seungwon Choi
@email     csw3575@snu.ac.kr
@date      2025-11-23
@copyright Seungwon Choi. All rights reserved.
-->

# MonoGS Docker Setup

Quick guide for running MonoGS with GPU support in Docker.

## Prerequisites

- NVIDIA GPU with driver installed
- Docker installed
- Ubuntu 18.04+

## Quick Start

### 1. Install NVIDIA Container Toolkit

```bash
./setup_nvidia_docker.sh
```

### 2. Build Docker Image

```bash
./build.sh
```

Build time: ~10-15 minutes

### 3. Run Container

```bash
./run.sh
```

## Download Dataset

```bash
# Full TUM-RGBD dataset
cd ../../
./scripts/download_tum_datasets.sh

# Single sequence (e.g., fr1_desk2)
cd datasets/TUM-RGBD
wget https://cvg.cit.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_desk2.tgz
tar -xzf rgbd_dataset_freiburg1_desk2.tgz && mv rgbd_dataset_freiburg1_desk2 fr1_desk2
```

## Run SLAM

```bash
# Enter container
docker exec -it monogs_benchmark bash

# Run monocular mode
cd /workspace/MonoGS
export WANDB_MODE=offline MPLBACKEND=Agg
python slam.py --config configs/mono/tum/fr1_desk.yaml

# Run RGBD mode
python slam.py --config configs/rgbd/tum/fr1_desk.yaml

# Evaluation mode (no GUI)
python slam.py --config configs/rgbd/tum/fr1_desk.yaml --eval
```

## Troubleshooting

**GPU memory full:**
```bash
docker restart monogs_benchmark
```

**GUI not showing:**
```bash
xhost +local:docker
```

## Docker Commands

```bash
docker ps -a                              # Check status
docker start/stop monogs_benchmark        # Start/stop
docker exec -it monogs_benchmark bash     # Enter container
docker logs monogs_benchmark              # View logs
```

---

**Author:** Seungwon Choi (csw3575@snu.ac.kr)  
**Date:** 2025-11-23
