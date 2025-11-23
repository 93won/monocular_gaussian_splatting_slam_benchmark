###############################################################################
# @file      Dockerfile
# @brief     Docker environment setup for MonoGS Gaussian Splatting SLAM
# @author    Seungwon Choi
# @email     csw3575@snu.ac.kr
# @date      2025-11-23
# @copyright Seungwon Choi. All rights reserved.
###############################################################################

# MonoGS Docker Environment
FROM nvidia/cuda:11.6.2-devel-ubuntu20.04

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX"
ENV FORCE_CUDA=1

# Install basic packages
RUN apt-get update && apt-get install -y \
    git \
    wget \
    build-essential \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libglfw3 \
    libglfw3-dev \
    python3.8 \
    python3.8-dev \
    python3-pip \
    python3.8-venv \
    python3-tk \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.8 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel

# Set working directory
WORKDIR /workspace

# Clone MonoGS with submodules
RUN git clone https://github.com/muskie82/MonoGS.git --recursive

WORKDIR /workspace/MonoGS

# Install PyTorch with CUDA 11.6 support
RUN pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 torchaudio==0.12.1 \
    --extra-index-url https://download.pytorch.org/whl/cu116

# Install other dependencies
RUN pip install \
    plyfile==0.8.1 \
    opencv-python==4.8.1.78 \
    munch \
    trimesh \
    evo==1.11.0 \
    open3d==0.17.0 \
    torchmetrics \
    imgviz \
    PyOpenGL \
    glfw \
    PyGLM \
    wandb \
    lpips \
    rich \
    ruff \
    tqdm

# Install ninja for faster CUDA extension builds
RUN pip install ninja

# Build and install submodules properly
RUN cd /workspace/MonoGS/submodules/diff-gaussian-rasterization && \
    python setup.py build_ext --inplace && \
    pip install . && \
    echo "✓ diff-gaussian-rasterization installed"

RUN cd /workspace/MonoGS/submodules/simple-knn && \
    python setup.py build_ext --inplace && \
    pip install . && \
    echo "✓ simple-knn installed"

# Add submodules to PYTHONPATH as backup
ENV PYTHONPATH="/workspace/MonoGS/submodules/diff-gaussian-rasterization:/workspace/MonoGS/submodules/simple-knn:${PYTHONPATH}"

# Set matplotlib to use Agg backend by default (headless)
ENV MPLBACKEND=Agg

# Default command
CMD ["/bin/bash"]
