#!/bin/bash

###############################
# Functions:
function isDir() {
  if [[ ! -d $1 ]]; then
    cat <<EOF
------------------------
Not exists "$1" directory!
Correct path: c:/path/to/folder/
-------------------------
EOF
    exit 1
  fi
}

function defaultDB() {
  cat <<EOF
-------------------
| db_name      = $1
| db_user_name = $1
| db_user_psw  = $1
-------------------
EOF
}

function initDB() {
  cat <<EOF
-------------------
Default:
| init_db_file = $1
-------------------
EOF
}

function usage() {
  cat <<EOF
------------------------
todo...
-------------------------
EOF
  exit 1
}

function dockerBuildStr() {
  cat <<EOF
docker build -t $1 \\
  --build-arg db_name=$2 \\
  --build-arg db_user_name=$2 \\
  --build-arg db_user_psw=$2 \\
  .
EOF
}

function dockerBuild() {
  echo "--------------------------------------------"
  echo "------------- Create Image -----------------"
  echo "--------------------------------------------"
  dockerBuildStr "$1" "$2"
  echo "--------------------------------------------"
  docker build -t "$1" \
  --build-arg db_name="$2" \
  --build-arg db_user_name="$2" \
  --build-arg db_user_psw="$2" \
  .
}

function runContainerStr() {
  cat <<EOF
docker run --rm -it \\
  --name $1 \\
  -v $2:/var/lib/postgresql/data \\
  -p 5444:5432 \\
  $3
EOF
}

function runContainer() {
  echo "-------------------------------------------------"
  echo "------------- Container Running -----------------"
  echo "-------------------------------------------------"
  runContainerStr "$1" "$2" "$3"
  echo "-------------------------------------------------"
  docker run --rm -it \
  --name "$1" \
  -v "$2":/var/lib/postgresql/data \
  -p 5444:5432 \
  "$3"
}

function clean() {
  docker rm $(docker stop $(docker ps -aq --filter name="$1"))
  docker system prune -f
}

function replaceVolumePath() {
  pwd=$1
  driver="${pwd:1:1}"
  echo "${driver}:${pwd:2}"
}

function databaseList() {
  DATABASE=$(ls -1 ./data)
  echo "-------------------------------------------------"
  echo "| DataBase lis:"
  echo "${DATABASE}"
  echo "-------------------------------------------------"
}

###############################
# Variables:
PROJECT_NAME=acolasz
DOCKER_APP_NAME=postgres
VERSION_TAG=13.0
IMAGE_NAME=${PROJECT_NAME}/${DOCKER_APP_NAME}:${VERSION_TAG}
BUILD_ARGS=docker
DOCKER_BUILD_PATH=.

LOCAL_VOLUME_PATH=""
VOLUME=${BUILD_ARGS}
CONTAINER_NAME="${VOLUME}"-postgres-db-1

BUILD=false
RUN=false
###############################

for arg in "$@"; do
  case $arg in
  -b | --build)
    BUILD=true
    shift
    ;;
  -r | --run)
    RUN=true
    shift
    ;;
  -db=* | --set-database=*)
    BUILD_ARGS="${arg#*=}"
    VOLUME="${BUILD_ARGS}"
    mkdir -p ./data/"${VOLUME}"
    PWD=$(pwd)
    LOCAL_VOLUME_PATH="${PWD}/data/${VOLUME}"
    isDir "${LOCAL_VOLUME_PATH}"
    LOCAL_VOLUME_PATH=$(replaceVolumePath "${LOCAL_VOLUME_PATH}")
    databaseList
    shift
    ;;
  *)
    OTHER_ARGUMENTS+=("$1")
    usage
    shift
    ;;
  esac
done

clean "${CONTAINER_NAME}"

if [ "${BUILD}" = true ]; then
  mkdir -p ./data/"${VOLUME}"
  PWD=$(pwd)
  LOCAL_VOLUME_PATH="${PWD}/data/${VOLUME}"
  isDir "${LOCAL_VOLUME_PATH}"
  LOCAL_VOLUME_PATH=$(replaceVolumePath "${LOCAL_VOLUME_PATH}")
  databaseList
  dockerBuild "${IMAGE_NAME}" "${BUILD_ARGS}"
fi

if [ "${RUN}" = true ]; then
  runContainer "${CONTAINER_NAME}" "${LOCAL_VOLUME_PATH}" "${IMAGE_NAME}"
fi
