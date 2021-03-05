#!/bin/bash

###############################
# Functions:
isDir() {
  cat <<EOF
------------------------
Not exists "$1" directory!
Correct path: c:/path/to/folder/
-------------------------
EOF
}

defaultDB() {
  cat <<EOF
-------------------
| db_name      = $1
| db_user_name = $1
| db_user_psw  = $1
-------------------
EOF
}

initDB() {
  cat <<EOF
-------------------
Default:
| init_db_file = $1
-------------------
EOF
}

usage() {
  cat <<EOF
------------------------
todo...
-------------------------
EOF
  exit 1
}

dockerBuildStr() {
  cat <<EOF
docker build -t $1 \\
  --build-arg db_name=$2 \\
  --build-arg db_user_name=$2 \\
  --build-arg db_user_psw=$2 \\
  --build-arg init_db_file=$3 \\
  .
EOF
}

dockerBuild() {
  echo "--------------------------------------------"
  echo "------------- Create Image -----------------"
  echo "--------------------------------------------"

  dockerBuildStr "$1" "$2" "$3"

  docker build -t "$1" \
  --build-arg db_name="$2" \
  --build-arg db_user_name="$2" \
  --build-arg db_user_psw="$2" \
  --build-arg init_db_file="$3" \
  .
}

runContainerStr() {
  cat <<EOF
docker run --rm -it --name "$1" -e POSTGRES_PASSWORD="$2" -p 5444:5432 "$3"
EOF
}

runContainer() {
  echo "-------------------------------------------------"
  echo "------------- Container Running -----------------"
  echo "-------------------------------------------------"
  runContainerStr "$1" "$2"
  docker run --rm -it --name "$1" -p 5444:5432 "$2"
}

clean() {
  docker rm $(docker stop $(docker ps -aq --filter name="$1"))
  docker system prune -f
}
###############################
# Variables:
PROJECT_NAME=acolasz
DOCKER_APP_NAME=postgres
VERSION_TAG=13.0
IMAGE_NAME=${PROJECT_NAME}/${DOCKER_APP_NAME}:${VERSION_TAG}
BUILD_ARGS=docker
BUILD_ARGS_INIT_FILE=init-default-db.sh

LOCAL_VOLUME_PATH=""
CONTAINER_NAME=default-postgres-db-1
DOCKER_BUILD_PATH=.

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
  *)
    OTHER_ARGUMENTS+=("$1")
    usage
    shift
    ;;
  esac
done

clean ${CONTAINER_NAME}

if [ "$BUILD" = true ]; then
  dockerBuild "${IMAGE_NAME}" "${BUILD_ARGS}" "${BUILD_ARGS_INIT_FILE}"
fi

if [ "$RUN" = true ]; then
  runContainer "${CONTAINER_NAME}" "${IMAGE_NAME}"
fi
