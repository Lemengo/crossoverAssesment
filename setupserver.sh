#!/bin/bash
echo "--> Getting Icinga prerequisite packages"
#!/bin/bash

set -e -x

# Needed so that the aptitude/apt-get operations will not be interactive
export DEBIAN_FRONTEND=noninteractive

add-apt-repository ppa:formorer/icinga --yes
apt-get --yes --quiet update && apt-get -y --quiet upgrade && apt-get -y --quiet install mysql-client htop git awscli

wget -qO- https://get.docker.com/ | sh

echo "--> Starting Docker"
service docker start
usermod -a -G docker ubuntu
su - ubuntu

# pull the docker images
echo "--> Pulling docker images"
docker pull mysql
docker pull httpd
docker pull php
# run the containers

echo "--> Running the docker instances"
git clone https://github.com/Lemengo/crossoverAssesment.git  && cd crossoverAssesment 
touch  ./Dockerfile
echo "FROM php:7.0-apache" >> Dockerfile
docker build -t crossoverassesment/local:apache .
cd ..
docker run -p 3700:3306 --name Mengo-mysql -e MYSQL_ROOT_PASSWORD=Lemengo12345 -d mysql:latest
docker run -dit -p 80:80 --name Mengo-apache --link Mengo-mysql:mysql -v /var/www/html/:/var/www/html crossoverassesment/local:apache

#Backup directory
mkdir backups 

sudo cp db.php index.php logout.php /var/www/html/
sudo cp dynamicronlog.sh /home/ubuntu && chmod +x /home/ubuntu/dynamicronlog.sh
sudo cp backup.sh /home/ubuntu && chmod +x /home/ubuntu/backup.sh
echo '* 19 * * * /home/ubuntu/dynamicronlog.sh' | crontab -
echo '* 19 * * * /home/ubuntu/backup.sh' | crontab -