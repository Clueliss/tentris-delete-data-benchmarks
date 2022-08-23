#!/bin/bash

main() {
  tentris_full_version="$1"
  echo "version ${tentris_full_version}"
  clone_and_build "${tentris_full_version}"
}

# clones and builds Tentris
function clone_and_build() {
  # args
  local version=$1

  local working_dir
  working_dir=$(pwd)

  tentris_code_dir="tentris_code_${version}"

  cd "${tentris_code_dir}" || exit

  conan_server > /dev/null &

  rm -rf build || true
  mkdir build && cd "$_" || exit
  build_with_docker "${version}"

  local tentris_deploy_dir
  tentris_deploy_dir="${working_dir}/tentris_${version}"

  rm -rf "${tentris_deploy_dir}" || true
  mkdir "${tentris_deploy_dir}" || exit

  cp ./* "${tentris_deploy_dir}"
  cd "$working_dir" || exit
}

# builds Tentris placed in the parent folder
function build_with_docker() {
  # args
  local version=$1

  local container_id
  local image_name="tentris_${version}"
  docker build --no-cache --build-arg TENTRIS_MARCH=native -t "${image_name}" ..
  container_id=$(docker create "${image_name}")
  docker cp "${container_id}":/tentris_server ./tentris_server
  docker cp "${container_id}":/tentris_loader ./tentris_loader
  docker cp "${container_id}":/rdf2ids ./rdf2ids
  docker cp "${container_id}":/ids2hypertrie ./ids2hypertrie
  docker container rm "${container_id}"
  docker image rm "${image_name}"
  echo "Binaries $(ls) were written to $(pwd)."
}

main "$@"
