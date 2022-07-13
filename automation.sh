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
cd /tmp
var=$(du -h $myname-httpd-logs-$timestamp.tar | awk '{print$1}')

sudo apt update
sudo apt install awscli -y

s3_bucket=upgrad-shatataraka
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar


File=/var/www/html/inventory.html
if [ -f "$File" ]; then
echo "inventory.html exists "
else
echo "inventory.html does not exists"
fi


{

echo "<table>"
echo "<thead>"
echo "<th>Log Type&emsp;</th>"
echo "<th>Date Created&emsp;&emsp;</th>"
echo "<th>Type&emsp;</th>"
echo "<th>Size&emsp;</th>"
echo "</thead>"
echo "</table>"
} > /var/www/html/inventory.html
{
echo "<tbody>"
echo "<tr>"
echo "<td>httpd-logs&emsp;</td>"
echo "<td>$timestamp&emsp;</td>"
echo "<td>tar&emsp;</td>"
echo "<td>$var&emsp;</td>"
} >> /var/www/html/inventory.html


echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
