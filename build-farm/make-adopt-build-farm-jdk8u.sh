#!/bin/bash

set -ex

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Very very build farm specific configuration

TIMESTAMP="$(date +'%Y%d%m%H%M')"

OPTIONS=""
PLATFORM=""
EXTENSION=""
CONFIGURE_ARGS_FOR_ANY_PLATFORM=""

export JDK_BOOT_DIR=$JDK7_BOOT_DIR

if [[ $NODE_LABELS = *"linux"* ]] ; then
  PLATFORM="Linux"
  EXTENSION="tar.gz"

  if [ ! -z "${TAG}" ]; then
    OPTIONS="${OPTIONS} --tag $TAG"
  fi
elif [[ $NODE_LABELS = *"mac"* ]] ; then
  PLATFORM="Mac"
  EXTENSION="tar.gz"

  export MACOSX_DEPLOYMENT_TARGET=10.8
  sudo xcode-select --switch /Applications/Xcode.app
elif [[ $NODE_LABELS = *"windows"* ]] ; then
  PLATFORM=Windows
  EXTENSION=zip

  export ANT_HOME=/cygdrive/C/Projects/OpenJDK/apache-ant-1.10.1
  export ALLOW_DOWNLOADS=true
  export PATH="/cygdrive/c/Program Files (x86)/Microsoft Visual Studio 10.0/VC/bin/amd64/:/cygdrive/C/Projects/OpenJDK/make-3.82/:$PATH"
  export LANG=C
  export JAVA_HOME=$JDK7_BOOT_DIR
  CONFIGURE_ARGS_FOR_ANY_PLATFORM="with_freetype=/cygdrive/C/Projects/OpenJDK/freetype --disable-ccache"
fi

# Set the file name
FILENAME="OpenJDK8_x64_${PLATFORM}_${TIMESTAMP}.${EXTENSION}"
echo "Filename will be: $FILENAME"

bash "$SCRIPT_DIR/../makejdk-any-platform.sh" --jdk-boot-dir "${JDK_BOOT_DIR}" --configure-args "${CONFIGURE_ARGS_FOR_ANY_PLATFORM}" --target-file-name "${FILENAME}" "${GIT_SHALLOW_CLONE_OPTION}" "${TAG_OPTION}" "${OPTIONS}" jdk8u