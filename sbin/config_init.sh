#!/usr/bin/env bash



# Give the array indexes all meaningful names, we can't use meaningful names until bash 4.x which Apple/Mac doesn't support because of GPL3
# This is why we can't have nice things.

CONFIG_PARAMS=(
OS_KERNEL_NAME
OS_ARCHITECTURE
OPENJDK_FOREST_NAME
OPENJDK_CORE_VERSION
BUILD_VARIANT
REPOSITORY
CONFIGURE_ARGS_FOR_ANY_PLATFORM
JDK_PATH
JRE_PATH
COPY_MACOSX_FREE_FONT_LIB_FOR_JDK_FLAG
COPY_MACOSX_FREE_FONT_LIB_FOR_JRE_FLAG
FREETYPE_FONT_BUILD_TYPE_PARAM
FREETYPE_FONT_VERSION
JVM_VARIANT
BUILD_FULL_NAME
MAKE_ARGS_FOR_ANY_PLATFORM
MAKE_COMMAND_NAME
OPENJDK_SOURCE_DIR
SHALLOW_CLONE_OPTION
DOCKER_SOURCE_VOLUME_NAME
CONTAINER_NAME
TMP_CONTAINER_NAME
CLEAN_DOCKER_BUILD
TARGET_DIR_IN_THE_CONTAINER
COPY_TO_HOST
USE_DOCKER
DOCKER_BUILD_PATH
KEEP
WORKING_DIR
USE_SSH
TARGET_DIR
BRANCH
TAG
OPENJDK_UPDATE_VERSION
OPENJDK_BUILD_NUMBER
JTREG
USER_SUPPLIED_CONFIGURE_ARGS
DOCKER
COLOUR
WORKSPACE_DIR
)

declare -a -x PARAM_LOOKUP
for index in $(seq 0 $(expr ${#CONFIG_PARAMS[@]} - 1))
do
    paramName=${CONFIG_PARAMS[$index]};
    eval declare -r -x $paramName=$index
    PARAM_LOOKUP[$index]=$paramName
done

function displayParams() {
    set +x
    echo "# OPENJDK BUILD CONFIGURATION:"
    echo "# ============================"
    for K in "${!BUILD_CONFIG[@]}";
    do
      echo BUILD_CONFIG[${PARAM_LOOKUP[$K]}]="\"${BUILD_CONFIG[$K]}\""
    done | sort
    set -x
}

function writeConfigToFile() {
  if [ ! -d "config" ]
  then
    mkdir config
  fi
  displayParams > ./config/built_config.cfg
}

function loadConfigFromFile() {
  if [ ! -d "config" ]
  then
    mkdir config
  fi
  source $SCRIPT_DIR/../config/built_config.cfg
}

# Declare the map of build configuration that we're going to use
declare -ax BUILD_CONFIG
export BUILD_CONFIG

# The OS kernel name, e.g. 'darwin' for Mac OS X
BUILD_CONFIG[OS_KERNEL_NAME]=$(uname | awk '{print tolower($0)}')

# The O/S architecture, e.g. x86_64 for a modern intel / Mac OS X
BUILD_CONFIG[OS_ARCHITECTURE]=$(uname -m)

# The full forest name, e.g. jdk8, jdk8u, jdk9, jdk9u, etc.
BUILD_CONFIG[OPENJDK_FOREST_NAME]=""

# The abridged openjdk core version name, e.g. jdk8, jdk9, etc.
BUILD_CONFIG[OPENJDK_CORE_VERSION]=""

# The build variant, e.g. openj9
BUILD_CONFIG[BUILD_VARIANT]=""

# The OpenJDK source code repository to build from, could be a GitHub AdoptOpenJDK repo, a mercurial forest etc
BUILD_CONFIG[REPOSITORY]=""