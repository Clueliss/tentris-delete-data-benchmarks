#! /bin/bash

mkdir -p {{ database_base_dir }}/blazegraph/{{ item[1].name }}

cd {{ database_base_dir }}/blazegraph/{{ item[1].name }}

time java -cp /opt/blazegraph/blazegraph.jar com.bigdata.rdf.store.DataLoader /opt/blazegraph/application.properties {{ item[1].path }}