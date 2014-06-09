#!/bin/sh
# Author: Melv Kim <melvkim@gmail.com>
# Project Home: https://github.com/melvkim/melvable
set -e

check_requirements() {
  # Check if melvable directory variable is set 
  if [ ! -n "${DIR_MELVABLE}" ]; then
      DIR_MELVABLE=~/.melvable
  fi

  # Die if melvable directoy exists 
  if [ -d "${DIR_MELVABLE}" ]; then
     echo "melvable exists in ${DIR_MELVABLE}"
     read -p "Do you wish to re-install melvable? [Y]es/[N]o: \c" prompt_yes_or_no
     case $prompt_yes_or_no in 
        [Yy]*) 
            "Removing existing melvable directory.."
            rm -rf ${DIR_MELVABLE}
            "Cloning melvable.."
            wget --quiet --no-check-certificate https://raw.github.com/melvkim/melvable/master/tool/install.sh -O - | sh
            ;;
        [Nn]*)
            die_on_warning "Melvable not installed."
            ;;
        *)
            die "Enter 'Yes' or 'No'"
            ;;
     esac
  fi
}

clone_melvable() {
  echo "Cloning melvable to ${DIR_MELVABLE}.."
  hash git >/dev/null 2>&1 && /usr/bin/env  git clone --quiet --recursive "https://github.com/melvkim/melvable" ${DIR_MELVABLE} || 
  die "git is not installed."
}

add_symbolic_link() {
  if test -h "/usr/local/bin/melvable"; then
    echo "Replacing melvable symbolic link.."
    sudo rm "/usr/local/bin/melvable"
  fi
  sudo ln -s "${DIR_MELVABLE}/tool/melvable.sh" "/usr/local/bin/melvable"
}

display_welcome() {
  echo "melvable is successfully installed."
  echo "Available images to install are:"
  \ls "${DIR_MELVABLE}/image"
}

die_on_warning() {
    echo "WARNING: $1"
    exit 2
    
}
die() {
    echo "ERROR: $1"
    exit 1
}

# main
check_requirements
clone_melvable
add_symbolic_link
display_welcome