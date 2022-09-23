#!/bin/bash

{% for triplestore_http in triplestores_http %}
# {{ triplestore_http.name }}
for run in {1..1}; do
    echo "run: $run"
    # {{ target_dir }}/loaders/{{ triplestore_http.name }}-load-dbpedia2015.sh
    {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/dbpedia2015/start.sh
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/dbpedia2015/1.yml
    {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/stop.sh
    # rm -rf {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015
done


{% endfor %}

{% for version in tentris_versions %}
# tentris-{{ version }}
for run in {1..1}; do
    echo "run: $run"
    # {{ target_dir }}/loaders/tentris-{{ version }}-load-dbpedia2015.sh
    {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/dbpedia2015/start.sh
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/dbpedia2015/1.yml
    {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/stop.sh
    # rm -rf {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015
done

{% endfor %}
