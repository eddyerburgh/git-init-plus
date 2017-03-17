#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Initialize empty git repo
git init

# Create LICENSE
touch LICENSE

# Create README.md
touch README.md

# Get options
while getopts l: option
do
        case "${option}"
        in
                l) license=${OPTARG};;
        esac
done

if [ "$license" ]; then
    cat ../licenses/MIT.txt >> ./LICENSE
fi

