#!/bin/bash

###############################################################################
# @file      download_tum_datasets.sh
# @brief     Download TUM-RGBD datasets (freiburg1, freiburg2, freiburg3)
# @author    Seungwon Choi
# @email     csw3575@snu.ac.kr
# @date      2025-11-23
# @copyright Seungwon Choi. All rights reserved.
###############################################################################

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base URL for TUM-RGBD dataset
BASE_URL="https://vision.in.tum.de/rgbd/dataset/freiburg"

# Dataset directory
DATASET_DIR="$(cd "$(dirname "$0")/.." && pwd)/datasets/TUM-RGBD"

echo -e "${GREEN}TUM-RGBD Dataset Downloader${NC}"
echo "Dataset will be downloaded to: $DATASET_DIR"
echo ""

# Create dataset directory
mkdir -p "$DATASET_DIR"

# Function to download and extract dataset
download_dataset() {
    local seq_name=$1
    local url=$2
    local output_dir="$DATASET_DIR/$seq_name"
    
    echo -e "${YELLOW}[Downloading]${NC} $seq_name"
    
    if [ -d "$output_dir" ]; then
        echo -e "${YELLOW}[Skip]${NC} $seq_name already exists"
        return
    fi
    
    # Download
    wget -P "$DATASET_DIR" "$url"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}[Error]${NC} Failed to download $seq_name"
        return 1
    fi
    
    # Extract
    local filename=$(basename "$url")
    echo -e "${YELLOW}[Extracting]${NC} $filename"
    tar -xzf "$DATASET_DIR/$filename" -C "$DATASET_DIR"
    
    # Rename to simple name
    local extracted_dir=$(tar -tzf "$DATASET_DIR/$filename" | head -1 | cut -f1 -d"/")
    mv "$DATASET_DIR/$extracted_dir" "$output_dir"
    
    # Clean up
    rm "$DATASET_DIR/$filename"
    
    echo -e "${GREEN}[Done]${NC} $seq_name"
}

# Freiburg 1 sequences
echo -e "${GREEN}=== Freiburg 1 Sequences ===${NC}"
download_dataset "fr1_desk" "${BASE_URL}1/rgbd_dataset_freiburg1_desk.tgz"
download_dataset "fr1_desk2" "${BASE_URL}1/rgbd_dataset_freiburg1_desk2.tgz"
download_dataset "fr1_room" "${BASE_URL}1/rgbd_dataset_freiburg1_room.tgz"
download_dataset "fr1_xyz" "${BASE_URL}1/rgbd_dataset_freiburg1_xyz.tgz"

echo ""
# Freiburg 2 sequences
echo -e "${GREEN}=== Freiburg 2 Sequences ===${NC}"
download_dataset "fr2_desk" "${BASE_URL}2/rgbd_dataset_freiburg2_desk.tgz"
download_dataset "fr2_xyz" "${BASE_URL}2/rgbd_dataset_freiburg2_xyz.tgz"
download_dataset "fr2_rpy" "${BASE_URL}2/rgbd_dataset_freiburg2_rpy.tgz"

echo ""
# Freiburg 3 sequences
echo -e "${GREEN}=== Freiburg 3 Sequences ===${NC}"
download_dataset "fr3_office" "${BASE_URL}3/rgbd_dataset_freiburg3_long_office_household.tgz"
download_dataset "fr3_structure_texture_near" "${BASE_URL}3/rgbd_dataset_freiburg3_structure_texture_near.tgz"
download_dataset "fr3_structure_texture_far" "${BASE_URL}3/rgbd_dataset_freiburg3_structure_texture_far.tgz"

echo ""
echo -e "${GREEN}✓ All downloads completed!${NC}"
echo "Datasets are available in: $DATASET_DIR"
