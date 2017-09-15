#!/bin/bash

app='nicky'

# Put the list of bins we want to compare into the $bins array
bins=()
for b in bin/*; do bins+=($b); done

# Read the list of all hosts for $app into the $hosts array
IFS=$'\n' read -d '' -r -a hosts < hosts

# Slice the hosts array to only keep as many hosts as we have bins to compare
hosts=("${hosts[@]:0:${#bins[@]}}")
echo "Hosts: ${hosts[@]}"

# Put the list of checks we want to modify into the $checks array
checks=()
for c in checks/*; do checks+=($c); done

# SCP the files to the hosts
for i in ${!hosts[@]}
do
	host=${hosts[$i]}
	bin=${bins[$i]}

	scp -C $bin stg.$host: &
	scp ${checks[@]} stg.$host: &
done

# Wait for scp to finish
wait

# Trim the prefix `checks/`
checks=("${checks[@]/checks\//}")

# Trim the prefix `bin/`
bins=("${bins[@]/bin\//}")

# Execute the `remote.sh` script on each host
for i in ${!hosts[@]}
do
	host=${hosts[$i]}
	bin=${bins[$i]}

	#Trim the prefix `$app-`
	version=${bin#$app-}

	ssh stg.$host BIN=$bin CHECKS=$checks APP=$app VERSION=$version 'bash -s' < remote.sh
done
