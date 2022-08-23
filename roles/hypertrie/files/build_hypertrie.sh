#!/bin/bash

hypertrie_version="$1"
hypertrie_code_dir="hypertrie_code_${hypertrie_version}"

cd "${hypertrie_code_dir}" || exit

conan_server > /dev/null &

conan user -r local -p hypertrie hypertrie
bash ./scripts/release.sh Release clang 14

sleep 5
exit 0
