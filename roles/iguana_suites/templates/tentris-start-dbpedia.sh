#!/bin/bash

cp -r {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015.save {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015
drop_caches
{{ target_dir }}/iguana_suites/http/tentris-{{ item }}/dbpedia2015/start.sh
