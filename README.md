# Automation_Project
The automation.sh script is created to host the web server and archieve log files.
The first step is to set up a apache2 web server on the EC2 instance for hosting a website.
It checks if apche2 is installed or not and then if not, it installs apache2 server. Script also ensures that apache2 is running and enabled.
Second step is to archieve web server logs. Script create tar file of access and error logs and copy it to the /tmp directoty.
It creates a backup of these logs by compressing the logs directory and archiving it to the s3 bucket (Storage).

automation.sh

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
