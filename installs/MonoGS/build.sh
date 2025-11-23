#!/bin/bash

###############################################################################
# @file      build.sh
# @brief     Build script for MonoGS Docker image
# @author    Seungwon Choi
# @email     csw3575@snu.ac.kr
# @date      2025-11-23
# @copyright Seungwon Choi. All rights reserved.
###############################################################################

echo "Building MonoGS Docker image..."
docker build -t monogs:latest .

if [ $? -eq 0 ]; then
    echo "✓ MonoGS Docker image built successfully!"
else
    echo "✗ Failed to build MonoGS Docker image"
    exit 1
fi
