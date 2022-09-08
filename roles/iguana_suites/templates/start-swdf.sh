#!/bin/bash

{{ target_dir }}/loaders/{{ item.name }}-load-swdf.sh
{{ target_dir }}/iguana_suites/http/{{ item.name }}/swdf/start.sh
