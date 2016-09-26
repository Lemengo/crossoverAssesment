#!/bin/bash

#Getting the docker instance hostnames
MYSQL=`docker ps |grep mysql |awk -F " " '{print $1}'`
APACHE=`docker ps |grep apache |awk -F " " '{print $1}'`
LOGS=/var/log/containers

if [ ! -d $LOGS ]; then
       mkdir $LOGS

fi

#Copying log files from docker instances to $LOGS
docker cp $APACHE:/var/log/apache2 $LOGS
docker cp $MYSQL:/var/log/mysql $LOGS

#Quebec is UTC-5:00 just as Virginia 
aws s3 sync /var/log/containers/ s3://mengo-assign --region us-east-1b 