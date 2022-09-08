#!/bin/bash

{{ target_dir }}/iguana_suites/http/{{ item.name }}/stop.sh
rm -rf {{ target_dir }}/databases/{{ item.name }}/swdf
