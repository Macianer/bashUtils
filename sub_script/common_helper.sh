#!/bin/sh
# common_helper.sh
# Author: Ronny Meißner

function msg { printf "%25s" "$@"; }

function try {
  "$@"
  if [[ $? != 0 ]]; then
    echo " [FAILED]"
    echo ""
    exit 1
  fi
  return $status
}

function appExists{
  hash "${1}" &> /dev/null
  if [ $? -eq 1 ]; then
      echo >&2 "${1} not installed or found."
      exit 1
  fi
}

# Installs a package for Linux only when needed.
# Usage: "packageLinux python python-software-properties"
function packageBrew {
    # check if install is required
    if [[ ${1} == /* ]]; then
        if [ ! -e "${1}" ]; then
            installBrew "${2}"
        fi
    else
        hash "${1}" 2>/dev/null || install "${2}"
    fi
}

# Installs a package with brew. Usage: installBrew package-name
function installBrew {
    brew "${1}"
}

# Installs a package for Linux only when needed.
# Usage: "packageLinux python python-software-properties"
function packageLinux {
    #
    if [[ ${1} == /* ]]; then
        if [ ! -e "${1}" ]; then
            installApt "${2}"
        fi
    else
        hash "${1}" 2>/dev/null || install "${2}"
    fi
}

# Installs a package with apt-get. Usage: installApt package-name
function installApt {
    sudo apt-get install -y "${1}" || ( sudo apt-get update && sudo apt-get install -y "${1}" ) || exit 2
}
