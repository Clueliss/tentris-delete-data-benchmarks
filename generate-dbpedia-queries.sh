#!/bin/zsh

SWDF_SIZE=294516
PERCENTAGES=(10 20 30 40 50 60 70 80 90 100)

clean_dbpedia() {
    riot --validate dbpedia_2015-10_en_wo-comments_c.nt 2>&1 | while read line; do
        echo $line
        local linenr="$(echo $line | grep -oP '\[line: \K[0-9]+')" 
    
        if [[ -n "$linenr" ]]; then
            echo $linenr
    	    echo $linenr >> bad-lines.txt
        fi
    done
    
    # remove lines from bad-lines.txt here
}

clean_changesets() {
    local last_file=""
    local buf=""

    riot --validate changesets/**/*.removed.nt 2>&1 | while read line; do
        local maybe_file="$(echo $line | grep -oP 'File: \K.+')"
    
        if [[ -n "$maybe_file" ]]; then
	    if [[ -n "$buf" ]]; then
  	        sed -i "${buf%;}" "$last_file"
  	        buf=""
    	    fi
    
    	    last_file="$maybe_file"
    	    continue;
        fi
    
    
        local linenr="$(echo $line | grep -oP '\[line: \K[0-9]+')" 
    
        if [[ -n "$linenr" ]]; then
    	    buf="${buf}${linenr}d;"
        fi
    done
}

prepare() {
    sparql_delete_data_generator compress -D -o dbpedia.compressor_state dbpedia-cleaned.nt
    sparql_delete_data_generator compress -i dbpedia.compressor_state -o dbpedia.compressor_state -r changesets
    sparql_delete_data_generator sort dbpedia-cleaned.compressed_nt
}

generate_changeset_queries() {
    sparql_delete_data_generator replicate -s dbpedia.compressor_state -C dbpedia-cleaned.compressed_nt -o dbpedia-queries/dbpedia-changeset-queries.txt -r changesets
}

generate_fixed_queries() {
    counts=""
    
    for p in ${PERCENTAGES[@]}; do
	local count=$(bc -l <<< "scale=0; $SWDF_SIZE * $p / 100")
	counts="$counts 3x$count"
    done
    
    sparql_delete_data_generator generate -s dbpedia.compressor_state -i dbpedia-cleaned.compressed_nt -o dbpedia-queries/fixed/dbpedia-fixed-queries-alt.txt randomized $counts
}

split_fixed_queries() {
    split --lines=3 --numeric-suffixes=0 --suffix-length=1 --additional-suffix=.txt dbpedia-fixed-queries-alt.txt dbpedia-query-
    
    for n in {0..9}; do
    	split --lines=1 --numeric-suffixes=1 --suffix-length=1 --additional-suffix=.txt dbpedia-query-$n.txt dbpedia-query-${PERCENTAGES[$n]}%-
    	rm dbpedia-query-$n.txt
    done
}


if ! [[ -f dbpedia-cleaned.nt ]]; then
    clean_changesets
    clean_dbpedia
    echo "clean dbpedia with bad-lines.txt now"
    exit 1
fi

if ! [[ -f dbpedia.compressor_state ]] && [[ -f dbpedia-cleaned.compressed_nt ]]; then
    prepare
fi

mkdir dbpedia-queries
mkdir dbpedia-queries/fixed

generate_changeset_queries
generate_fixed_queries

cd dbpedia-queries
split_fixed_queries

