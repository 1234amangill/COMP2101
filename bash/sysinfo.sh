#!/bin/bash

hname=`hostname`

domain=`hostname -f`

os_vers=`cat /etc/os-release |  grep PRETTY |  awk -F'"' '{print $2}'`

ips=`hostname -I`

file=`df -h --output=avail /`

cat <<EOF

REPORT FOR $hname
=======================
FQDN: $domain
Operating System: 
	$os_vers
IP Address: 
	$ips
Root Filesystem Status:
	$file
============================

EOF
