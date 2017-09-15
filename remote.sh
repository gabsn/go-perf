#!/bin/bash

app_path='/usr/local/bin'
datadog_config='datadog.yaml'
datadog_config_path='/etc/dd-agent/datadog.yaml'
checks_path='/opt/datadog-agent6/agent/checks.d'

# Disable chef-client for the next hour
sudo chef-deviate disable "Restarting $APP with the $VERSION version" 1h

# Replace the checks to get all expvar metrics
sudo cp $CHECKS $checks_path
rm $CHECKS

# Change the permissions of $datadog_config file to be able to modify it
sudo cp $datadog_config_path .
sudo chmod 777 $datadog_config

# If the file has already been modified, we cut the last lines.
# The original file should only have 34 lines.
lines=$(wc -l < $datadog_config)
if [ $lines -gt 34 ]; then
	sudo sed -n 1,34p $datadog_config > temp
	cat temp > $datadog_config
	rm temp
fi

# Append the custom `ddtracego` tag to all the metrics sent by this host
sudo cat <<EOT >> $datadog_config
tags:
  - app-version:$VERSION
EOT

# Put the permissions as they were before and update the file
sudo chmod 640 $datadog_config
sudo cp $datadog_config $datadog_config_path
rm $datadog_config

# Restart the agent
sudo service datadog-agent6 restart

# Restart the $APP
sudo service $APP stop 
sudo cp $BIN $app_path/$APP 
sudo service $APP start
