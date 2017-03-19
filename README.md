# git-init-plus

Shell script to kick start a git project

Initializes git, creates LICENSE, adds .gitignore (from [universal-gitignore](https://github.com/eddyerburgh/universal-gitignore)) and creates a README.md with your project title.

## Installation

On linx/unix run:

```shell
wget https://raw.githubusercontent.com/eddyerburgh/git-init-plus/master/install.sh && chmod +x install.sh && sudo ./install.sh
```

This script downloads the install file, makes it executable and runs it.

The install file clones this directory to /opts/git-init-plus and creates a sym-link for the git-init-plus script in /usr/local/bin 

## Usage

```
git-init-plus
```

Will walk you through creation of a new git project.

```
git-init-plus -l ISC -n Edd -p project-name
```

Will initialize git, add an ISC LICENSE, a README.md with project-name as a title and a .gitignore file.

If .git, README.md or LICENSE already exist, git-init-plus will prompt you to verify whether it should replace the file.

## Options

| Parameter | Usage         | Example        |
| --------- | ------------- | -------------- |
| -h        | prints out usage | git-init-plus -h |
| -l        | name of license to create | git-init-plus -l Apache |
| -n        | name of copyright holder(s) to be added to LICENSE | git-init-plus -n Edd |
| -p | project name to be added as title to README.md | git-init-plus -p git-init-plus

