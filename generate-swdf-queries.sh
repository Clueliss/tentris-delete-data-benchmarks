#!/bin/bash

# This script shows how the contained queries were generated for reference puposes

set -euo pipefail

PERCENTAGES=(10 20 30 40 50 60 70 80 90 100)

prepare_dataset() {
    sparql_delete_data_generator compress -D -o swdf.compressor_state swdf.nt
}

generate_queries() {
    mkdir swdf-queries

    for p in ${PERCENTAGES[@]}; do
    	local dup_flag
    	
    	if [[ $p -lt 40 ]]; then
    	    dup_flag="-d"
    	fi
    
    	sparql_delete_data_generator generate -s swdf.compressor_state -i swdf.compressed_nt -o swdf-queries/swdf-queries-$p%.txt randomized $dup_flag 3x$p%
    done
}

split_queries() {
    for p in ${PERCENTAGES[@]}; do
        split --lines=1 --numeric-suffixes=1 --suffix-length=1 --additional-suffix=.txt swdf-queries-$p%.txt swdf-query-$p%-
        rm swdf-queries-$p%.txt
    done
}

if ! [[ -f swdf.compressor_state ]] && [[ -f swdf.compressed_nt ]]; then
    prepare_dataset
fi 

generate_queries
cd swdf-queries
split_queries

