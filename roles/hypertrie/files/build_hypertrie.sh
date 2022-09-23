#!/bin/bash

set -e

#conan_profile="Release_clang-14_hypertrie_profile"
#
#prepare() {
#    if [ -f ~/.local/bin/conan ]; then
#        export PATH="${HOME}/.local/bin:${PATH}"
#    fi
#
#    conan profile new --detect --force "${conan_profile}"
#    conan profile update settings.compiler="clang" "${conan_profile}"
#    conan profile update settings.compiler.version="14" "${conan_profile}"
#    conan profile update settings.compiler.libcxx=libstdc++11 "${conan_profile}"
#    conan profile update env.CXXFLAGS="-march=native" "${conan_profile}"
#    conan profile update env.CXX="clang++-14" "${conan_profile}"
#    conan profile update env.CC="clang-14" "${conan_profile}"
#
#    conan remote add -f dice-group https://conan.dice-research.org/artifactory/api/conan/tentris
#}
#
#release() {
#    hypertrie_deploy_version=$(conan inspect . --raw version)
#
#    conan remote add -f hypertrie_tmp http://localhost:9300
#    conan user -s -r hypertrie_tmp -p hypertrie hypertrie 
#    conan remove -f "hypertrie/$hypertrie_deploy_version@dice-group/stable" || true
#    conan create . "hypertrie/$hypertrie_deploy_version@dice-group/stable" --build missing -e hypertrie_deploy_version="$hypertrie_deploy_version" --profile ${conan_profile}
#    conan upload "hypertrie/$hypertrie_deploy_version@dice-group/stable" --force --all -r hypertrie_tmp
#    conan remote remove hypertrie_tmp
#}

conan_server_dir="$1"
conan_server --server_dir "$conan_server_dir" &
sleep 5 # wait for server to start

docker build --tag hypertrie_tmp --network host .
docker image rm hypertrie_tmp

sleep 5 # wait for server to finish processing

exit 0
