#!/usr/bin/env bash
set -euo pipefail

shopt -s expand_aliases

function patch_readlink() {
	[[ $(uname) == 'Darwin' ]] && {
		# shellcheck disable=SC2015
		which greadlink gsed >/dev/null && {
			[[ $(type -t readlink) == "alias" ]] && unalias readlink
			[[ $(type -t sed) == "alias" ]] && unalias sed
			alias readlink=greadlink sed=gsed
		} || {
			echo 'ERROR: GNU utils required for Mac. You may use homebrew to install them: brew install coreutils gnu-sed'
			exit 1
		}
	}
}

patch_readlink

#/ Usage: git-init-plus [options]
#/ Description: Init a git project, LICENSE, README and .gitignore
#/ Examples: git-init-plus -l MIT -n Edd -p project-name
#/ Options:
#/   -l name of license to create (defaults to MIT)
#/   -n name(s) of copyright holder(s) to be added to LICENSE
#/   -p project name to be added as title to README.md
#/   -h: Display this help message
#/   --help: Display this help message
usage() {
	grep '^#/' "$0" | cut -c4-
	exit 0
}
expr "$*" : ".*--help" >/dev/null && usage
expr "$*" : ".*-h" >/dev/null && usage

# Logger
readonly LOG_FILE="/tmp/git-init-plus.log"
info() { echo "$@" | tee -a "$LOG_FILE" >&2; }
fatal() {
	echo "$@" | tee -a "$LOG_FILE" >&2
	exit 1
}

command -v git >/dev/null 2>&1 || { fatal "git-init-plus requires git but it's not installed.  Aborting."; }

# Path variables
WORKING_PATH="$(pwd)"
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# Options
license=
name=
project_name=
while getopts l:n:p: option; do
	case "${option}" in

	l) license=${OPTARG} ;;
	n) name=${OPTARG} ;;
	p) project_name=${OPTARG} ;;
	esac
done

initialize_git_repo() {
	# Initialize empty git repo
	if [ -d "$WORKING_PATH/.git" ]; then
		read -r -p ".git already exists in directory, do you want to reinitialize? [y/N] " response
		case "$response" in
		[yY][eE][sS] | [yY])
			git init
			;;
		*)
			fatal "Program exiting"
			;;
		esac
	else
		git init
	fi
}

create_license() {
	touch LICENSE
	LICENSE="$WORKING_PATH/LICENSE"

	if [ "$license" ]; then
		license_reference_file="$SCRIPT_PATH/resources/licenses/$license.txt"
		if [ ! -e "$license_reference_file" ]; then
			licenses_list=""
			for file in $SCRIPT_PATH/resources/licenses/*.txt; do
				if [ ! "$licenses_list" ]; then
					licenses_list=$(basename "${file%.*}")
				else
					licenses_list="$licenses_list, $(basename "${file%.*}")"
				fi
			done
			fatal "Invalid license passed to function. Available licenses are ${licenses_list}"
		fi
		cat "$license_reference_file" >>"$LICENSE"
		info "Created $license license"

	else
		cat "$SCRIPT_PATH/resources/licenses/MIT.txt" >>"$LICENSE"
		info "No license specified, defaulting to MIT (pass license with -l arg)"
	fi

	# Add name to license
	if [ "$name" ]; then
		sed -i "s/<copyright holders>/$name/g" "$LICENSE"
	else
		while [[ $name == '' ]]; do
			read -r -p "What is the name(s) of the copyright holder(s):" name
		done
		sed -i "s/<copyright holders>/$name/g" "$LICENSE"
		info "Name added to license"
	fi

	# Add date to license
	sed -i "s/<year>/$(date +"%Y")/g" "$LICENSE"

	# Create README.md
	README="$WORKING_PATH/README.md"
	[ -e "$README" ] && rm "$README"
	touch "$README"

	# Add project name as title of README
	if [ "$project_name" ]; then
		echo "# $(tr '[:upper:]' '[:lower:]' <<<"$project_name")" >"$README"
	else
		while [[ $project_name == '' ]]; do
			read -r -p "What is the name your project (added as title to README):" project_name
		done
		echo "# $(tr '[:upper:]' '[:lower:]' <<<"$project_name")" >"$README"
		info "Title added to README"
	fi

}

create_gitignore() {
	# Copy .gitignore
	GITIGNORE="$WORKING_PATH/.gitignore"
	[ -e "$GITIGNORE" ] && rm "$GITIGNORE"
	cp "$SCRIPT_PATH/resources/.gitignore" "$GITIGNORE"
	info ".gitignore added"
}

git_init_plus() {
	initialize_git_repo
	create_license
	create_gitignore
	info "Success! New project initialized"
}

git_init_plus
