#!/bin/bash

set -e

release() {
    source scripts/internal/find_conan.sh

    find_conan
    
    conan_profile="Release_clang-14_hypertrie_profile"

    hypertrie_deploy_version=$(conan inspect . --raw version)

    conan remove -f "hypertrie/$hypertrie_deploy_version@dice-group/stable" || true
    conan create . "hypertrie/$hypertrie_deploy_version@dice-group/stable" --build missing -e hypertrie_deploy_version="$hypertrie_deploy_version" --profile ${conan_profile}
    conan upload "hypertrie/$hypertrie_deploy_version@dice-group/stable" --force --all -r local
}


conan_server_dir="$1"
conan_server --server_dir "$conan_server_dir" &

cd hypertrie_code
release

sleep 5
exit 0
