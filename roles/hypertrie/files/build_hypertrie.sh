#!/bin/bash

set -e

release() {
    source scripts/internal/find_conan.sh

    find_conan
    
    conan_profile="Release_clang-14_hypertrie_profile"

    hypertrie_deploy_version=$(conan inspect . --raw version)

    conan remote add -f hypertrie_tmp http://localhost:9300
    conan user -r hypertrie_tmp -p hypertrie hypertrie 
    conan remove -f "hypertrie/$hypertrie_deploy_version@dice-group/stable" || true
    conan create . "hypertrie/$hypertrie_deploy_version@dice-group/stable" --build missing -e hypertrie_deploy_version="$hypertrie_deploy_version" --profile ${conan_profile}
    conan upload "hypertrie/$hypertrie_deploy_version@dice-group/stable" --force --all -r hypertrie_tmp
    conan remote remove hypertrie_tmp
}


conan_server_dir="$1"
conan_server --server_dir "$conan_server_dir" &
sleep 5 # wait for server to start

cd hypertrie_code
release
sleep 5 # wait for server to finish processing

exit 0
