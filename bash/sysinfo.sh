#!/bin/bash


echo "Host Name: `hostname -f`"
echo "Domain Name: `hostname -d`"
echo -e "\nOperating System name and version: \n`cat /etc/os-release | grep PRETTY_NAME=`"
echo -e "\nIP Addresses: \n`hostname -i`"
echo -e "\nRoot Filesystem Status:\n`df -h /`"

