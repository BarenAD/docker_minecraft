#!/bin/bash

mkdir -p dist

echo "Preparing..."

bash ./src/prepare.sh

echo "Cleanup image..."

sudo docker rmi barenad/minecraft:java_25

echo "Build..."

sudo docker build . --platform linux/amd64 -t barenad/minecraft:java_25

sudo docker images

echo "Successfully completed!"
