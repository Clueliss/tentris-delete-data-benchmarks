#!/bin/bash

set -euo pipefail

image_name="sparql-delete-data-generator"

git clone https://github.com/Clueliss/sparql-delete-data-generator
cd sparql-delete-data-generator

docker build --no-cache -t "$image_name" .

container_id=$(docker create $image_name)
docker cp "$container_id:/usr/local/src/sparql-delete-data-generator/target/release/sparql_delete_data_generator" .

docker container rm "$container_id"
docker image rm "$image_name"

exit 0
