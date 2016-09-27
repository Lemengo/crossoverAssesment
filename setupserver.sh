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
mkdir -p php-deploy && cd php-deploy 
touch  ./Dockerfile
echo "FROM php:7.0-apache" >> Dockerfile
echo "COPY /var/www/html/ /var/www/html/" >> Dockerfile
docker build -t php-deploy:Mengo-apache .
cd ..
git clone https://github.com/Lemengo/crossoverAssesment.git  && cd crossoverAssesment && docker build -t crossoverAssesment/local:apache .

docker run -p 3700:3306 --name Mengo-mysql -e MYSQL_ROOT_PASSWORD=Lemengo12345 -d mysql:latest
docker run -dit -p 90:80 --name Mengo-apache --link Mengo-mysql:mysql -v /var/www/html/:/var/www/html crossoverAssesment/local:apache

#Backup directory
mkdir backups 

cp db.php index.php logout.php /var/www/html/
cp dynamicronlog.sh /root && chmod +x /root/dynamicronlog.sh
cp backup.sh /root && chmod +x /root/backup.sh
echo '* 19 * * * /root/cronlogs.sh' | crontab -
echo '* 19 * * * /root/backup.sh' | crontab -