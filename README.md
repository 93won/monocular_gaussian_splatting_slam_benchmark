# Monocular Gaussian Splatting SLAM Benchmark

Benchmark repository for evaluating monocular Gaussian Splatting-based SLAM methods.

## Overview

This repository provides a unified benchmarking framework for:
- **MonoGS**: Monocular Gaussian Splatting SLAM
- **Photo-SLAM**: (Coming soon)
- **Splat-SLAM**: (Coming soon)

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/93won/monocular_gaussian_splatting_slam_benchmark.git
cd monocular_gaussian_splatting_slam_benchmark
```

### 2. Download Dataset

```bash
./scripts/download_tum_datasets.sh
```

### 3. Setup & Run Method

Each method has its own installation guide:

- **MonoGS**: See [MonoGS.md](MonoGS.md)
- **Photo-SLAM**: Coming soon
- **Splat-SLAM**: Coming soon

## Repository Structure

```
.
├── installs/          # Docker configurations for each method
│   └── MonoGS/
│       ├── Dockerfile
│       ├── build.sh
│       ├── setup_nvidia_docker.sh
│       └── configs/   # Pre-configured settings
├── datasets/          # TUM-RGBD, Replica, etc. (downloaded by scripts)
│   └── TUM-RGBD/
├── results/           # Output results
│   └── MonoGS/
└── scripts/           # Utility scripts
    └── download_tum_datasets.sh
```

## Supported Datasets

- **TUM-RGBD**: Freiburg 1/2/3 sequences
- **Replica**: (Coming soon)
- **EuRoC**: (Coming soon)

## Methods

### MonoGS

- **Status**: ✅ Ready
- **Mode**: Monocular / RGBD
- **Docker**: `installs/MonoGS/`
- **Details**: See `installs/MonoGS/README.md`

### Photo-SLAM

- **Status**: 🔄 Coming soon

### Splat-SLAM

- **Status**: 🔄 Coming soon

## Requirements

- NVIDIA GPU with CUDA support
- NVIDIA GPU Driver
- Docker
- Ubuntu 18.04+
