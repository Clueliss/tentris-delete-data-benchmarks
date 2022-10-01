#! /bin/bash

if [[ -f {{ target_dir }}/virtuoso.pid ]]
then
    echo $(date --iso-8601) - Virtuoso seems to be already running
    echo If it is not running remove virtuoso.pid
    exit 1
fi


echo $(date --iso-8601) - Starting Virtuoso
{{ target_dir }}/triplestores/virtuoso/{{ virtuoso_version }}/virtuoso-opensource/bin/virtuoso-t -c {{ target_dir }}/triplestores/virtuoso/virtuoso-run-{{ item[1].name }}.ini

echo $(date --iso-8601) - Waiting for Virtuoso to become available

while :
do
    curl -s 127.0.0.1:8890
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 2
done

echo $(date --iso-8601) - Setting update permissions
{{ target_dir }}/triplestores/virtuoso/{{ virtuoso_version }}/virtuoso-opensource/bin/isql 'exec=grant SPARQL_UPDATE to "SPARQL"'

echo $(date --iso-8601) - Virtuoso started and accepting connections

exit 0
