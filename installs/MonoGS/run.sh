#!/bin/bash

###############################################################################
# @file      run.sh
# @brief     Run script for MonoGS Docker container
# @author    Seungwon Choi
# @email     csw3575@snu.ac.kr
# @date      2025-11-23
# @copyright Seungwon Choi. All rights reserved.
###############################################################################

# Set X11 forwarding permission for GUI
xhost +local:docker

echo "Starting MonoGS container..."

# Remove existing container if it exists
docker rm -f monogs_benchmark 2>/dev/null

# Run container
docker run -d --name monogs_benchmark \
  --runtime=nvidia --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics \
  -e DISPLAY=$DISPLAY \
  -v $(pwd)/../../methods/MonoGS:/workspace/MonoGS \
  -v $(pwd)/../../datasets:/workspace/datasets \
  -v $(pwd)/../../results/MonoGS:/workspace/results \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --shm-size=8gb \
  --network=host \
  -it monogs:latest

echo ""
echo "✓ MonoGS container started!"
echo ""
echo "To enter the container:"
echo "  docker exec -it monogs_benchmark bash"
echo ""
echo "To run SLAM (inside container):"
echo "  cd /workspace/MonoGS"
echo "  export WANDB_MODE=offline MPLBACKEND=Agg"
echo "  python slam.py --config configs/rgbd/tum/fr1_desk.yaml"
