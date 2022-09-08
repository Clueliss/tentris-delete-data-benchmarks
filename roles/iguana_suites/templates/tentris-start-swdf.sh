#!/bin/bash

{{ target_dir }}/loaders/tentris-{{ item }}-load-swdf.sh
{{ target_dir }}/iguana_suites/http/tentris-{{ item }}/swdf/start.sh
