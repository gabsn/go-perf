#!/bin/bash

# First replace the checks to get all expvar metrics and resart the agent
sudo cp $CHECKS $CHECKS_PATH
sudo service datadog-agent6 restart

# Second restart the bins
sudo service $SERVICE stop 
sudo cp $BIN $SERVICE_PATH/$SERVICE 
sudo service $SERVICE start
