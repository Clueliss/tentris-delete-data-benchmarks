#!/bin/bash

{% for triplestore_http in triplestores_http %}
# {{ triplestore_http.name }}
{{ target_dir }}/loaders/{{ triplestore_http.name }}-load-dbpedia2015.sh

for run in {1..{{ iguana_repetitions }}}; do
    echo "run: $run"
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/dbpedia2015/1.yml
done

rm -rf {{ target_dir }}/databases/{{ triplestore_http.name }}/dbpedia2015

{% endfor %}

{% for version in tentris_versions %}
# tentris-{{ version }}
{{ target_dir }}/loaders/tentris-{{ version }}-load-dbpedia2015.sh

for run in {1..{{ iguana_repetitions }}}; do
    echo "run: $run"
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/tentris/{{ version }}/dbpedia2015/1.yml
done

rm -rf {{ target_dir }}/databases/tentris/{{ version }}/dbpedia2015

{% endfor %}
