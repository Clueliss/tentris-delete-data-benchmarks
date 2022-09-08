#!/bin/bash

{{ target_dir }}/iguana_suites/http/tentris-{{ item }}/stop.sh
rm -rf {{ target_dir }}/databases/tentris/{{ item }}/swdf
