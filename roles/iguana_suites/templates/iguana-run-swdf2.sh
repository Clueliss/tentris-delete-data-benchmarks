#!/bin/bash

{% for triplestore_http in triplestores_http %}
{{ triplestore_http.name }}() {
    # {{ triplestore_http.name }}
    drop_caches
    for run in {1..{{ iguana_swdf_repetitions }}}; do
        echo "run: $run"
        {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/{{ triplestore_http.name }}/swdf/2.yml
    done
}

{% endfor %}

tentris() {
{% for version in tentris_versions %}
    # tentris-{{ version }}
    drop_caches
    for run in {1..{{ iguana_swdf_repetitions }}}; do
        echo "run: $run"
        {{ target_dir }}/iguana-run.sh {{ target_dir }}/iguana_suites/http/tentris-{{ version }}/swdf/2.yml
    done

{% endfor %}
}


{% for triplestore_http in triplestores_http %}
{{ triplestore_http.name }}
{% endfor %}

tentris
