#!/bin/bash
set -e

# Build Container
# Note if there is a gemfile / gemfile.lock you may need to delete it to get this running
docker build . -t jekyll

# Run with live reload

docker run -p 4000:4000 -v ${PWD}:/site jekyll 
