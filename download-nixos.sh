#!/bin/sh
# Copyright (c) 2018 slowtec GmbH <post@slowtec.de>

NAME="nixos"
RELEASE="18.03"
UPDATE="132500.2f6440eb09b"
MINIMAL_ISO="https://nixos.org/releases/nixos/${RELEASE}/nixos-$RELEASE.$UPDATE/nixos-minimal-$RELEASE.$UPDATE-x86_64-linux.iso"
GFX_ISO="https://nixos.org/releases/nixos/${RELEASE}/nixos-$RELEASE.$UPDATE/nixos-graphical-$RELEASE.$UPDATE-x86_64-linux.iso"
ISO_URL=$MINIMAL_ISO
FILE="$NAME.iso"
COUNT=0

function createSHAUrl {
  SHA_URL="$ISO_URL.sha256"
}

function download {
  echo "Downloading ISO image $ISO_URL"
  wget -q $ISO_URL -O $FILE
}

function clean {
  rm ".CHECKSUMS"
  rm ".$NAME.sha256"
}

function check {
  echo "Checking current ISO image '$FILE'"
  wget -q $SHA_URL -O ".$NAME.sha256"
  echo "`cat .$NAME.sha256` $FILE" > ".CHECKSUMS"
  sha256sum -c --status --strict "./.CHECKSUMS"
  local status=$?
  if [ $status -ne 0 ]; then
    echo "ISO image '$FILE' is not valid"
    if [ $COUNT -eq 0 ]; then
      let COUNT++
      download
      check
    else
      echo "Could not download a valid ISO image '$FILE'"
      clean
      exit 1
    fi
  else
    echo "ISO image '$FILE' is valid"
    clean
    exit 0
  fi
}

while getopts ":g:" optname
  do
    case "$optname" in
      "?")
        echo "Unknown option $OPTARG"
        ;;
      ":")
        if [ $OPTARG == 'g' ]; then
          ISO_URL=$GFX_ISO
          FILE="$NAME-graphical.iso"
        else
          echo "No argument value for option $OPTARG"
        fi
        ;;
      *)
        echo "Unknown error"
        ;;
    esac
  done

createSHAUrl

if [ -f "$FILE" ]; then
  check
else
  download
  check
fi
