#!/bin/bash

{% for triplestore_http in triplestores_http %}
# {{ triplestore_http.name }}
for run in {1..{{ iguana_repetitions }}}; do
    echo "run: $run"
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/swdf/1.yml
done

{% endfor %}

{% for version in tentris_versions %}
# tentris-{{ version }}
for run in {1..{{ iguana_repetitions }}}; do
    echo "run: $run"
    {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/tentris/{{ version }}/swdf/1.yml
done

{% endfor %}
