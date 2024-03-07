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
repository=${r:-"uniprimeroxacrdev.azurecr.io"}
with_latest=${l:-false}
build_registry=${b:-""}

BUILD_NGINX="docker build -f ./docker/nginx/Dockerfile . -t potm/nginx:${tag} -t ${repository}/bahmni-msf-primero/nginx:${tag} --build-arg NGINX_UID=${NGINX_UID} --build-arg NGINX_GID=${NGINX_GID} --build-arg BUILD_REGISTRY=${build_registry}"
#BUILD_SOLR="docker build -f ./docker/solr/Dockerfile . -t bahmni-msf-primero/solr:${tag} -t ${repository}/bahmni-msf-primero/solr:${tag} --build-arg BUILD_REGISTRY=${build_registry}"
BUILD_APP="docker build -f ./docker/application/Dockerfile . -t potm/application:${tag} -t ${repository}/bahmni-msf/primero:${tag} --build-arg APP_ROOT=${APP_ROOT} --build-arg RAILS_LOG_PATH=${RAILS_LOG_PATH} --build-arg APP_UID=${APP_UID} --build-arg APP_GID=${APP_GID} --build-arg BUILD_REGISTRY=${build_registry}"
#BUILD_MIGRATION="docker build -f migration/Dockerfile ../ -t primero/migration:${tag} -t ${repository}/primero/migration:${tag} --build-arg BUILD_REGISTRY=${build_registry} --build-arg PRIMERO_VERSION=${tag}"

apply_tags_and_push () {
  local image=${1}
  local subtag=${2:-""}
  [[ -n "${subtag}" ]] && subtag="-${subtag}"

  docker tag "potm/${image}:${tag}${subtag}" "${repository}/potm/${image}:${tag}${subtag}" > /dev/null
  if [[ "${with_latest}" == true ]] ; then
    docker tag "potm/${image}:${tag}${subtag}" "potm/${image}:latest${subtag}" > /dev/null
    docker tag "${repository}/potm/${image}:${tag}${subtag}" "${repository}/potm/${image}:latest${subtag}" > /dev/null
  fi
  # Push the tagged images to the repository
  docker push "${repository}/potm/${image}:${tag}${subtag}" > /dev/null
  if [[ "${with_latest}" == true ]] ; then
    docker push "${repository}/potm/${image}:latest${subtag}" > /dev/null
  fi
  # Output the image name
  echo "${repository}/potm/${image}:${tag}${subtag}"
  if [[ "${with_latest}" == true ]] ; then
    echo "${repository}/potm/${image}:latest${subtag}"
  fi
}

# this could use getopts for building multiple containers
case ${image} in
  nginx)
    eval "${BUILD_NGINX}" && apply_tags_and_push nginx
    ;;
  # solr)
  #   eval "${BUILD_SOLR}" && apply_tags_and_push solr
  #   ;;
  application)
    eval "${BUILD_APP}" && apply_tags_and_push application
    ;;
  # migration)
  #   eval "${BUILD_APP}" && apply_tags_and_push application
  #   eval "${BUILD_MIGRATION}" && apply_tags_and_push migration
  #   ;;
  all)
    eval "${BUILD_APP}" && apply_tags_and_push application
    # eval "${BUILD_MIGRATION}" && apply_tags_and_push migration
    # eval "${BUILD_SOLR}" && apply_tags_and_push solr
    eval "${BUILD_NGINX}" && apply_tags_and_push nginx
    ;;
  *)
    echo "${USAGE}"
    exit 1
  ;;
esac
