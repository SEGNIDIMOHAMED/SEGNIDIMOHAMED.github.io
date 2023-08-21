#!/bin/bash
set -e

# Build Container
docker build . -t jekyll

# Run with live reload

docker run -p 4000:4000 -v ${PWD}:/site jekyll 