# git-init-plus

Shell script to kick start a git project

Initializes git, creates LICENSE, adds .gitignore (from [universal-gitignore](https://github.com/eddyerburgh/universal-gitignore)) and creates a README.md with your project title
## Table of contents

* [Installation](#installation)
   * [Linux](#installation-linux)
   * [OSX](#installation-osx)
   * [Windows](#installation-windows)
* [Usage](#usage)
* [Options](#options)

## <a name="installation"></a>Installation

### <a name="installation-linux"></a>Linux

In your terminal run:

```shell
wget https://raw.githubusercontent.com/eddyerburgh/git-init-plus/master/install.sh && chmod +x install.sh && sudo ./install.sh
```

This script downloads the install file, makes it executable and runs it

The install file adds this directory to /opts/git-init-plus and creates a sym-link for the git-init-plus script in /usr/local/bin

### <a name="installation-osx"></a>OSX

```shell
curl -O https://raw.githubusercontent.com/eddyerburgh/git-init-plus/master/install.sh && chmod +x install.sh && sudo ./install.sh
```

And add usr/local/bin to PATH, in ```~/.bash_profile```

```shell
export PATH="/usr/local/bin:$PATH"
```

### <a name="installation-windows"></a>Windows

Currently unavailable

## <a name="usage"></a>Usage

```shell
git-init-plus
```

Will walk you through creation of a new git project

```shell
git-init-plus -l ISC -n Edd -p project-name
```

Will initialize git, add an ISC LICENSE, a README.md with project-name as a title and a .gitignore file

If .git, README.md or LICENSE already exist, git-init-plus will prompt you to verify whether it should replace the file

## <a name="options"></a>Options

| Parameter | Usage         | Example        |
| --------- | ------------- | -------------- |
| -l        | name of license to create (defaults to MIT) | git-init-plus -l Apache |
| --license | name of license to create (defaults to MIT) | git-init-plus --license Apache |
| -n        | name(s) of copyright holder(s) to be added to LICENSE | git-init-plus -n Edd |
| --name    | name(s) of copyright holder(s) to be added to LICENSE | git-init-plus --name Edd |
| -p        | project name to be added as title to README.md | git-init-plus -p git-init-plus
| --project-name | project name to be added as title to README.md | git-init-plus --project-name git-init-plus
| -h        | prints out usage | git-init-plus -h |
| --help    | prints out usage | git-init-plus --help |
