#!/usr/bin/env bash
set -euo pipefail

function gip_patch_readlink() {
	shopt -s expand_aliases
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

gip_patch_readlink

gip_echo() {
  command printf %s\\n "$*" 2>/dev/null || {
    nvm_echo() {
      # shellcheck disable=SC1001
      \printf %s\\n "$*" # on zsh, `command printf` sometimes fails
    }
    nvm_echo "$@"
  }
}

gip_usage() {
	gip_echo ""
	gip_echo "gip_usage: git-init-plus [options]"
	gip_echo ""
	gip_echo "Description: Init a git project, LICENSE, README and .gitignore"
	gip_echo ""
	gip_echo "Examples: git-init-plus -l MIT -n Edd -p project-name"
	gip_echo ""
	gip_echo "Options:"
	gip_echo "  -l name of license to create (defaults to MIT)"
	gip_echo "  --license name of license to create (defaults to MIT)"
	gip_echo "  -n name(s) of copyright holder(s) to be added to LICENSE"
  gip_echo "  --name name(s) of copyright holder(s) to be added to LICENSE"
  gip_echo "  -p project name to be added as title to README.md"
  gip_echo "  --project-name project name to be added as title to README.md"
  gip_echo "  -h: Display this help message"
  gip_echo "  --help: Display this help message"
	exit 0
}

gip_create_logger() {
	# Logger
	readonly LOG_FILE="/tmp/git-init-plus.log"
	gip_info() { echo "$@" | tee -a "$LOG_FILE" >&2; }
	gip_fatal() {
		echo "$@" | tee -a "$LOG_FILE" >&2
		exit 1
	}
}

gip_check_git_is_installed() {
	command -v git >/dev/null 2>&1 || { gip_fatal "git-init-plus requires git but it's not installed.  Aborting."; }
}

WORKING_PATH=
SCRIPT=
SCRIPT_PATH=

license=
name=
project_name=

gip_create_path_variables() {
	WORKING_PATH="$(pwd)"
	SCRIPT=$(readlink -f "$0")
	SCRIPT_PATH=$(dirname "$SCRIPT")
}

function gip_parse_options() {
	while [[ $# -gt 0 ]]; do
		key="$1"

		case $key in
		-p | --project-name)
			project_name="$2"
			shift
			;;
		-n | --name)
			name="$2"
			shift
			;;
		-l|--license)
			license="$2"
			shift
			;;
		-h|--help)
			gip_usage
			exit
			;;
		*)
			gip_usage
			exit
			;;
		esac
		shift
	done
}

gip_initialize_git_repo() {
	# Initialize empty git repo
	if [ -d "$WORKING_PATH/.git" ]; then
		read -r -p ".git already exists in directory, do you want to reinitialize? [y/N] " response
		case "$response" in
		[yY][eE][sS] | [yY])
			git init
			;;
		*)
			gip_fatal "Program exiting"
			;;
		esac
	else
		git init
	fi
}

gip_create_license() {
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
			gip_fatal "Invalid license passed to function. Available licenses are ${licenses_list}"
		fi
		cat "$license_reference_file" >>"$LICENSE"
		gip_info "Created $license license"

	else
		cat "$SCRIPT_PATH/resources/licenses/MIT.txt" >>"$LICENSE"
		gip_info "No license specified, defaulting to MIT (pass license with -l arg)"
	fi

	# Add name to license
	if [ "$name" ]; then
		sed -i "s/<copyright holders>/$name/g" "$LICENSE"
	else
		while [[ $name == '' ]]; do
			read -r -p "What is the name(s) of the copyright holder(s):" name
		done
		sed -i "s/<copyright holders>/$name/g" "$LICENSE"
		gip_info "Name added to license"
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
		gip_info "Title added to README"
	fi
}

gip_create_gitignore() {
	# Copy .gitignore
	GITIGNORE="$WORKING_PATH/.gitignore"
	[ -e "$GITIGNORE" ] && rm "$GITIGNORE"
	cp "$SCRIPT_PATH/resources/.gitignore" "$GITIGNORE"
	gip_info ".gitignore added"
}

git_init_plus() {
	gip_create_logger
	gip_parse_options "$@"
	gip_create_path_variables "$@"
	gip_check_git_is_installed
	gip_initialize_git_repo
	gip_create_license
	gip_create_gitignore
	gip_info "Success! New project initialized"
}

git_init_plus "$@"
#!/usr/bin/env bash
set -euo pipefail

function gip_patch_readlink() {
	shopt -s expand_aliases
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

gip_patch_readlink

#/ gip_usage: git-init-plus [options]
#/ Description: Init a git project, LICENSE, README and .gitignore
#/ Examples: git-init-plus -l MIT -n Edd -p project-name
#/ Options:
#/   -l name of license to create (defaults to MIT)
#/   -n name(s) of copyright holder(s) to be added to LICENSE
#/   -p project name to be added as title to README.md
#/   -h: Display this help message
#/   --help: Display this help message
gip_usage() {
	grep '^#/' "$0" | cut -c4-
	exit 0
}

gip_create_logger() {
	# Logger
	readonly LOG_FILE="/tmp/git-init-plus.log"
	gip_info() { echo "$@" | tee -a "$LOG_FILE" >&2; }
	gip_fatal() {
		echo "$@" | tee -a "$LOG_FILE" >&2
		exit 1
	}
}

gip_check_git_is_installed() {
	command -v git >/dev/null 2>&1 || { gip_fatal "git-init-plus requires git but it's not installed.  Aborting."; }
}

WORKING_PATH=
SCRIPT=
SCRIPT_PATH=

license=
name=
project_name=

gip_create_path_variables() {
	WORKING_PATH="$(pwd)"
	SCRIPT=$(readlink -f "$0")
	SCRIPT_PATH=$(dirname "$SCRIPT")
}

function gip_parse_options() {
	while [[ $# -gt 0 ]]; do
		key="$1"

		case $key in
		-p | --extension)
			project_name="$2"
			shift
			;;
		-n | --searchpath)
			name="$2"
			shift
			;;
		-l)
			license="$2"
			shift
			;;
		-h | --help)
			gip_usage
			exit
			;;
		*)
			gip_usage
			exit
			;;
		esac
		shift
	done
}

gip_initialize_git_repo() {
	# Initialize empty git repo
	if [ -d "$WORKING_PATH/.git" ]; then
		read -r -p ".git already exists in directory, do you want to reinitialize? [y/N] " response
		case "$response" in
		[yY][eE][sS] | [yY])
			git init
			;;
		*)
			gip_fatal "Program exiting"
			;;
		esac
	else
		git init
	fi
}

gip_create_license() {
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
			gip_fatal "Invalid license passed to function. Available licenses are ${licenses_list}"
		fi
		cat "$license_reference_file" >>"$LICENSE"
		gip_info "Created $license license"

	else
		cat "$SCRIPT_PATH/resources/licenses/MIT.txt" >>"$LICENSE"
		gip_info "No license specified, defaulting to MIT (pass license with -l arg)"
	fi

	# Add name to license
	if [ "$name" ]; then
		sed -i "s/<copyright holders>/$name/g" "$LICENSE"
	else
		while [[ $name == '' ]]; do
			read -r -p "What is the name(s) of the copyright holder(s):" name
		done
		sed -i "s/<copyright holders>/$name/g" "$LICENSE"
		gip_info "Name added to license"
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
		gip_info "Title added to README"
	fi
}

gip_create_gitignore() {
	# Copy .gitignore
	GITIGNORE="$WORKING_PATH/.gitignore"
	[ -e "$GITIGNORE" ] && rm "$GITIGNORE"
	cp "$SCRIPT_PATH/resources/.gitignore" "$GITIGNORE"
	gip_info ".gitignore added"
}

git_init_plus() {
	gip_create_logger
	gip_parse_options "$@"
	gip_create_path_variables "$@"
	gip_check_git_is_installed
	gip_initialize_git_repo
	gip_create_license
	gip_create_gitignore
	gip_info "Success! New project initialized"
}

git_init_plus "$@"
