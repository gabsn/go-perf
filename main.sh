#!/bin/bash
checks_path='/opt/datadog-agent6/agent/checks.d'
service='nicky'
service_path='/usr/local/bin'

# List of hosts
hosts=(i-063dad0e3998b7e84 i-03cde3a370a4b5a70)

# List of binaries to send
bins=()
for b in bin/*; do bins+=($b); done

# List of agent checks to replace
checks=()
for c in checks/*; do checks+=($c); done

#for host in ${hosts[@]}
#do
#	scp -C ${bins[@]} stg.$host: &
#	scp ${checks[@]} stg.$host: &
#done
#
## Wait for scp to finish
#wait

# Trim the prefix `checks/`
checks=("${checks[@]/checks\//}")

# Trim the prefix `bin/`
bins=("${bins[@]/bin\//}")

for i in ${!hosts[@]}
do
	host=${hosts[$i]}
	bin=${bins[$i]}
	echo "------------------------------------------" 
	echo "Host: $host -> $bin"
	echo "------------------------------------------" 

	ssh stg.$host BIN=$bin CHECKS=$checks CHECKS_PATH=$checks_path SERVICE=$service SERVICE_PATH=$service_path 'bash -s' < remote.sh
done
