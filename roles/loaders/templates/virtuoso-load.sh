#! /bin/bash

mkdir -p {{ database_base_dir }}/virtuoso/{{ item[1].name }}/database
mkdir -p {{ database_base_dir }}/virtuoso/{{ item[1].name }}/vad
mkdir -p {{ database_base_dir }}/virtuoso/{{ item[1].name }}/vsp

systemctl start virtuoso@{{ item[1].name }}.service

sleep 30 # Wait for server to come online

/opt/virtuoso/7.2.5/virtuoso-opensource/bin/isql << EOF
ld_dir ('{{ item[1].path | regex_replace('^(.*)/.*\.nt$', '\\1') }}', '*.nt', 'http://dbpedia.org');
rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);
EOF

systemctl stop virtuoso@{{ item[1].name }}.service