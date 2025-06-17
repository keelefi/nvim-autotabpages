#!/usr/bin/env bash

set -e

DOCKER_IMAGE_NAME=nvim_autotabpages

docker build -t "${DOCKER_IMAGE_NAME}" .

docker run --rm -t "${DOCKER_IMAGE_NAME}" /data/nvim-autotabpages/run-tests.sh
