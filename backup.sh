#!/bin/bash
# A Simple Shell Script to Backup Apache Webserver and MySQL Database in Docker Instances
# Path to backup directories
DIRS="/var/www/html/ /etc"
BFILE="$(hostname).$(date +'%T').tar.gz"
# Store todays date
NOW=$(date +"%F")
# Store backup path
BACKUP="/backup/$NOW"

#Move to the backup directory
cd backups
# Backup websever dirs
$TAR -zcvf ${BACKUP}/${BFILE} "${DIRS}"
# Backup MySQL
docker run -it --link Mengo-mysql:mysql --rm mysql sh -c 'exec mysqldump -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"' > mysqldbs_dump.sql
tar zcvf ${BACKUP}/${BFILE} "${DIRS}"

#Quebec is UTC-5:00 just as Virginia 
aws s3 sync backups s3://mengo-assign --region us-east-1 