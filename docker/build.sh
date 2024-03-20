#!/bin/bash
# Copyright (c) 2014 - 2023 UNICEF. All rights reserved.

set -euxo pipefail

# Grab the variables set in the defaults
# These must be passed in explicitly with --build-arg
# and the defined again as an
source ./docker/defaults.env
test -e ./local.env && source ./local.env

USAGE="Usage ./build application|migration|nginx|solr|all [-t <tag>] [-r <repository>] [-b <registry>] [-l]"

if [[ $# -eq 0 ]]; then
  echo "${USAGE}"
  exit 1
fi

image=${1}
shift || true

while getopts "t:r:b:l" opt ; do
  case ${opt} in
    t )
      t=$OPTARG
    ;;
    r )
      r=$OPTARG
    ;;
     b )
      b="${OPTARG}/"
    ;;
    l )
      l=true
    ;;
    \? )
      echo "${USAGE}"
      exit 1
    ;;
  esac
done
shift $((OPTIND -1)) || true

tag=${t:-latest}
repository=${r:-""}
with_latest=${l:-false}
build_registry=${b:-"uniprimeroxacrdev.azurecr.io"}

BUILD_NGINX="docker build -f ./docker/nginx/Dockerfile ./docker -t ${repository}:${tag} --build-arg NGINX_UID=${NGINX_UID} --build-arg NGINX_GID=${NGINX_GID} --build-arg BUILD_REGISTRY=${build_registry}"
BUILD_SOLR="docker build -f ./docker/solr/Dockerfile . -t ${repository}:${tag} --build-arg BUILD_REGISTRY=${build_registry}"
BUILD_APP="docker build -f ./docker/application/Dockerfile . -t ${repository}:${tag} --build-arg APP_ROOT=${APP_ROOT} --build-arg RAILS_LOG_PATH=${RAILS_LOG_PATH} --build-arg APP_UID=${APP_UID} --build-arg APP_GID=${APP_GID} --build-arg BUILD_REGISTRY=${build_registry}"

apply_tags_and_push () {
  local image=${1}
  local subtag=${2:-""}
  [[ -n "${subtag}" ]] && subtag="-${subtag}"

  docker tag "${repository}:${tag}${subtag}" "${build_registry}/${repository}:${tag}${subtag}" > /dev/null
  if [[ "${with_latest}" == true ]] ; then
    docker tag "${repository}:${tag}${subtag}" "${repository}:latest${subtag}" > /dev/null
    docker tag "${repository}:${tag}${subtag}" "${build_registry}/${repository}:latest${subtag}" > /dev/null
  fi
  # Push the tagged images to the repository
  docker push "${build_registry}/${repository}:${tag}${subtag}" > /dev/null
  if [[ "${with_latest}" == true ]] ; then
    docker push "${build_registry}/${repository}:latest${subtag}" > /dev/null
  fi
  # Output the image name
  echo "${build_registry}/${repository}:${tag}${subtag}"
  if [[ "${with_latest}" == true ]] ; then
    echo "${build_registry}/${repository}:latest${subtag}"
  fi
}

# Parse image names and corresponding ECR repositories
# IFS=',' read -r -a images <<< "${IMAGE_NAMES}"
# IFS=',' read -r -a ecr_repos <<< "${ECR_REPO}"

# Loop through each image and its corresponding repository
# for (( i=0; i<${#images[@]}; i++ )); do
#   image_name="${images[i]}"
#   ecr_repo="${ecr_repos[i]}"

  case ${image} in
    nginx)
      eval "${BUILD_NGINX}" && apply_tags_and_push nginx
      ;;
    solr)
      eval "${BUILD_SOLR}" && apply_tags_and_push solr
      ;;
    application)
      eval "${BUILD_APP}" && apply_tags_and_push application
      ;;
    all)
      eval "${BUILD_APP}" && apply_tags_and_push application
      # eval "${BUILD_MIGRATION}" && apply_tags_and_push migration
      eval "${BUILD_SOLR}" && apply_tags_and_push solr
      eval "${BUILD_NGINX}" && apply_tags_and_push nginx
      ;;
    *)
      echo "${USAGE}"
      exit 1
    ;;
  esac
# done
