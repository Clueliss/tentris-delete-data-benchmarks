#! /bin/bash

if [[ -f {{ target_dir }}/fuseki.pid ]]
then
    echo $(date --iso-8601) - Fuseki seems to be already running
    echo If it is not running remove fuseki.pid
    exit 1
fi

echo $(date --iso-8601) - Starting Fuseki

dir=$(pwd)

export FUSEKI_BASE={{ target_dir }}/triplestores/fuseki/apache-jena-fuseki-{{ fuseki_version }}
cd {{ target_dir }}/triplestores/fuseki/apache-jena-fuseki-{{ fuseki_version }}

java -Xmx{{ item[1].max_ram }}K -XX:ActiveProcessorCount=1 -jar {{ target_dir }}/triplestores/fuseki/apache-jena-fuseki-{{ fuseki_version }}/fuseki-server.jar --update --tdb2 --loc={{ target_dir }}/databases/fuseki/{{ item[1].name }} /{{ item[1].name }} </dev/null 2>&1 >{{ target_dir }}/logs/run/fuseki-{{ item[1].name }}.log & disown
pid=$!

echo $pid > {{ target_dir }}/fuseki.pid

echo $(date --iso-8601) - Waiting for Fuseki to become available

while :
do
    curl -s 127.0.0.1:3030
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 2
done

echo $(date --iso-8601) - Fuseki started and accepting connections

cd $dir
