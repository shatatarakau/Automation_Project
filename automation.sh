#!/bin/bash

sudo apt update -y
echo "Packages updated"
dpkg --get-selections | grep apache2
if [ $? -eq 0 ]; then
    echo "Apache2 is installed!"
else
    echo "Apache2 is NOT installed!"
fi

echo "Installing Apache2"
sudo apt-get install apache2 -y

sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2

echo "Checking if apche2 is running and enabled"
ps -ef | grep apache2
sudo systemctl list-unit-files --state=enabled | grep apache2

echo "Archieve apache2 log files"
myname=shatataraka
timestamp=$(date '+%d%m%Y-%H%M%S')

cd /var/log/apache2/
ls
tar -cvf $myname-httpd-logs-$timestamp.tar access.log error.log
mv $myname-httpd-logs-$timestamp.tar /tmp
sudo apt update
sudo apt install awscli -y

s3_bucket=upgrad-shatataraka
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar






