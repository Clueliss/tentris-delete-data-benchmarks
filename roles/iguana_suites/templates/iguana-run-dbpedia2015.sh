#!/bin/bash

{% for triplestore_http in triplestores_http %}
# {{ triplestore_http.name }}

mv {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015 {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015.save || exit 1

for run in {1..{{ iguana_dbpedia_repetitions }}}; do
    echo "run: $run"
    rm -rf {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015
    cp -r {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015.save {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015
    
    drop_caches
    {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/dbpedia2015/start.sh
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/dbpedia2015/1.yml
    {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/stop.sh
done

{% endfor %}

{% for version in tentris_versions %}
# tentris-{{ version }}

mv {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015 {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015.save || exit 1

for run in {1..{{ iguana_dbpedia_repetitions }}}; do
    echo "run: $run"
    rm -rf {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015
    cp -r {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015.save {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015
    
    drop_caches
    {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/dbpedia2015/start.sh
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/dbpedia2015/1.yml
    {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/stop.sh
done

{% endfor %}
