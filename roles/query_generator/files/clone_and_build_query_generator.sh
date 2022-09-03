#!/bin/bash

set -euo pipefail

image_name="sparql-delete-data-generator"

git clone https://github.com/Clueliss/sparql-delete-data-generator
cd sparql-delete-data-generator

podman build --no-cache -t "$image_name" .

container_id=$(podman create $image_name)
podman cp "$container_id:/usr/local/src/sparql-delete-data-generator/target/release/sparql_delete_data_generator" .

podman container rm "$container_id"
podman image rm "$image_name"

exit 0
