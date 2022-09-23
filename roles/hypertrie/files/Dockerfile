FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y python3 python3-pip clang-14 cmake make && \
    pip3 install conan

RUN conan profile new --detect --force default && \
    conan profile update settings.compiler="clang" default && \
    conan profile update settings.compiler.version="14" default && \
    conan profile update settings.compiler.libcxx=libstdc++11 default && \
    conan profile update env.CXXFLAGS="-march=native" default && \
    conan profile update env.CXX="clang++-14" default && \
    conan profile update env.CC="clang-14" default && \
    conan remote add -f dice-group https://conan.dice-research.org/artifactory/api/conan/tentris

COPY hypertrie_code /hypertrie
WORKDIR /hypertrie

RUN conan remote add -f hypertrie_tmp http://localhost:9300 && \
    conan user -s -r hypertrie_tmp -p hypertrie hypertrie && \
    conan remove -f "hypertrie/0.9.0@dice-group/stable" || true && \
    conan create . "hypertrie/0.9.0@dice-group/stable" --build missing -e hypertrie_deploy_version="0.9.0" --profile default && \
    conan upload "hypertrie/0.9.0@dice-group/stable" --force --all -r hypertrie_tmp
