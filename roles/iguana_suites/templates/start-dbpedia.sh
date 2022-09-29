#!/bin/bash

cp -r {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015.save {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015
drop_caches
{{ target_dir }}/iguana_suites/http/{{ item.name }}/dbpedia2015/start.sh
