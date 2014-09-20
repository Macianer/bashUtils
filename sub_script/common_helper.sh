#!/bin/sh
#
#

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