#!/bin/bash
datadog=datadog.yaml

# Disable chef-client
sudo chef-deviate disable "Restarting $SERVICE with the $VERSION version of dd-trace-go" 1h

# Replace the checks to get all expvar metrics
sudo cp $CHECKS $CHECKS_PATH

# Use custom tags for this host
sudo cp $DATADOG_CONFIG .
sudo chmod 777 $datadog
lines=$(wc -l < $datadog)
if [ $lines > 34 ]; then
	sudo sed -n 1,34p $datadog > temp
	cat temp > $datadog
fi
sudo cat <<EOT >> $datadog
tags:
  - ddtracego:$VERSION
EOT
sudo chmod 640 $datadog
sudo cp $datadog $DATADOG_CONFIG

# Restart the agent
sudo service datadog-agent6 restart

# Restart the bins
sudo service $SERVICE stop 
sudo cp $BIN $SERVICE_PATH/$SERVICE 
sudo service $SERVICE start
