#!/bin/bash

set -e

main() {
  if [ -f ~/.local/bin/conan ]; then
    export PATH="${HOME}/.local/bin:${PATH}"
  fi

  tentris_full_version="$1"
  conan_server_dir="$2"
  echo "version ${tentris_full_version}"
  clone_and_build "${tentris_full_version}" "$conan_server_dir"
}

# clones and builds Tentris
function clone_and_build() {
  # args
  local version=$1
  local conan_server_dir="$2"

  local working_dir
  working_dir=$(pwd)

  tentris_code_dir="tentris_code_${version}"

  cd "${tentris_code_dir}"

  conan_server --server_dir "$conan_server_dir" &
  sleep 5 # wait for server startup

  rm -rf build || true
  mkdir build && cd "$_"
  build_with_docker "${version}"

  local tentris_deploy_dir
  tentris_deploy_dir="${working_dir}/tentris_${version}"

  rm -rf "${tentris_deploy_dir}" || true
  mkdir "${tentris_deploy_dir}"

  cp ./* "${tentris_deploy_dir}"
  cd "$working_dir"
}

# builds Tentris placed in the parent folder
function build_with_docker() {
  # args
  local version=$1

  local container_id
  local image_name="tentris_${version}"
  docker build --no-cache --network host --build-arg MARCH=native -t "${image_name}" ..
  
  container_id=$(docker create "${image_name}")
  docker cp "${container_id}":/tentris_server ./tentris_server
  docker cp "${container_id}":/tentris_loader ./tentris_loader
  
  docker container rm "${container_id}"
  docker image rm "${image_name}"
  echo "Binaries $(ls) were written to $(pwd)."
}

main "$@"
