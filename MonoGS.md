# MonoGS Installation and Usage Guide

Complete guide for installing and running MonoGS with Docker.

## Prerequisites

- NVIDIA GPU with CUDA support
- NVIDIA GPU Driver installed
- Docker installed
- Ubuntu 18.04+

## Installation

### 1. Install NVIDIA Container Toolkit (First time only)

```bash
cd installs/MonoGS
./setup_nvidia_docker.sh
```

This script will:
- Add NVIDIA Container Toolkit repository
- Install nvidia-container-toolkit
- Configure Docker with NVIDIA runtime
- Test GPU access in Docker

### 2. Build Docker Image

```bash
./build.sh
```

Build time: ~10-15 minutes

The image includes:
- CUDA 11.6.2 development environment
- PyTorch 1.12.1 with CUDA 11.6
- MonoGS and all dependencies
- CUDA extensions (diff-gaussian-rasterization, simple-knn)
- OpenGL/GUI libraries
- python3-tk for matplotlib

### 3. Start Container

```bash
cd installs/MonoGS
docker rm -f monogs_benchmark  # Remove existing container
docker run -d --name monogs_benchmark \
  --runtime=nvidia --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics \
  -e DISPLAY=$DISPLAY \
  -v $(pwd)/configs:/workspace/MonoGS/configs \
  -v $(pwd)/../../datasets:/workspace/datasets \
  -v $(pwd)/../../results:/workspace/results \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --shm-size=8gb \
  --network=host \
  -it monogs:latest
```

## Download Dataset

### Option 1: Full TUM-RGBD Dataset (Recommended)

```bash
cd ~/monocular_gaussian_splatting_slam_benchmark
./scripts/download_tum_datasets.sh
```

Downloads all sequences:
- Freiburg 1: desk, desk2, room, xyz
- Freiburg 2: desk, xyz, rpy
- Freiburg 3: office, long_office_household

### Option 2: Individual Sequence

Example for fr1_desk2:
```bash
cd ~/monocular_gaussian_splatting_slam_benchmark/datasets/TUM-RGBD
wget https://cvg.cit.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_desk2.tgz
tar -xzf rgbd_dataset_freiburg1_desk2.tgz
mv rgbd_dataset_freiburg1_desk2 fr1_desk2
rm rgbd_dataset_freiburg1_desk2.tgz
```

## Running MonoGS

### Enter Container

```bash
docker exec -it monogs_benchmark bash
```

### Run Monocular Mode

```bash
cd /workspace/MonoGS
export WANDB_MODE=offline
export MPLBACKEND=Agg

# With GUI
python slam.py --config configs/mono/tum/fr1_desk.yaml

# Without GUI (evaluation mode)
python slam.py --config configs/mono/tum/fr1_desk.yaml --eval
```

### Run RGBD Mode

```bash
cd /workspace/MonoGS
export WANDB_MODE=offline
export MPLBACKEND=Agg

# With GUI
python slam.py --config configs/rgbd/tum/fr1_desk.yaml

# Without GUI (evaluation mode)
python slam.py --config configs/rgbd/tum/fr1_desk.yaml --eval
```

## Available Config Files

### Monocular Mode
- `configs/mono/tum/fr1_desk.yaml`
- `configs/mono/tum/fr2_xyz.yaml`
- `configs/mono/tum/fr3_office.yaml`

### RGBD Mode
- `configs/rgbd/tum/fr1_desk.yaml`
- `configs/rgbd/tum/fr2_xyz.yaml`
- `configs/rgbd/tum/fr3_office.yaml`

## Results

Results are saved in:
```bash
~/monocular_gaussian_splatting_slam_benchmark/results/
```

Output includes:
- `trajectory.txt` - Estimated camera trajectory
- `*.png` - Rendered images
- `*.ply` - Gaussian point cloud data
- ATE/RPE evaluation metrics
- wandb logs (offline mode)

## Adding New Sequences

### 1. Download Dataset
See "Download Dataset" section above.

### 2. Create Config File

Copy existing config:
```bash
cd methods/MonoGS/configs/mono/tum
cp fr1_desk.yaml fr1_desk2.yaml
```

Edit `fr1_desk2.yaml`:
```yaml
inherit_from: "configs/mono/tum/base_config.yaml"

Dataset:
  dataset_path: "/workspace/datasets/TUM-RGBD/fr1_desk2"
  Calibration:
    fx: 517.306408
    fy: 516.469215
    cx: 318.643040
    cy: 255.313989
    # ... camera parameters
```

### 3. Run SLAM

```bash
python slam.py --config configs/mono/tum/fr1_desk2.yaml
```

## Troubleshooting

### GPU Memory Full

```bash
# Check GPU memory
nvidia-smi

# Restart container to free memory
docker restart monogs_benchmark
```

### GUI Not Showing

```bash
# Enable X11 forwarding
xhost +local:docker

# Check DISPLAY variable
echo $DISPLAY
```

### CUSOLVER Error

This usually means GPU memory is full. Restart the container:
```bash
docker restart monogs_benchmark
```

### Matplotlib/tkinter Error

Already fixed in Dockerfile with:
- `python3-tk` package installed
- `MPLBACKEND=Agg` environment variable

### Dataset Path Error

Make sure config file has correct path:
```yaml
Dataset:
  dataset_path: "/workspace/datasets/TUM-RGBD/fr1_desk"
```

## Docker Commands Reference

```bash
# Check container status
docker ps -a

# Start/stop/restart container
docker start monogs_benchmark
docker stop monogs_benchmark
docker restart monogs_benchmark

# Remove container
docker rm -f monogs_benchmark

# Remove image
docker rmi monogs:latest

# View logs
docker logs monogs_benchmark

# Check GPU inside container
docker exec monogs_benchmark nvidia-smi
```

## Directory Structure

```
monocular_gaussian_splatting_slam_benchmark/
├── installs/MonoGS/
│   ├── Dockerfile
│   ├── build.sh
│   ├── run.sh
│   └── setup_nvidia_docker.sh
├── methods/MonoGS/          # Mounted to /workspace/MonoGS
│   ├── slam.py
│   ├── configs/
│   └── ...
├── datasets/TUM-RGBD/       # Mounted to /workspace/datasets
│   ├── fr1_desk/
│   └── ...
└── results/MonoGS/          # Mounted to /workspace/results
```

## Author

**Seungwon Choi**  
Email: csw3575@snu.ac.kr  
Date: 2025-11-23
