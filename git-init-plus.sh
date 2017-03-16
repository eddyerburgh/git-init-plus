#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Initialize empty git repo
git init

# Create LICENSE
touch LICENSE

# Create README.md
touch README.md