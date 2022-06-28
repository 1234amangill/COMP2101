#!/bin/bash

# Make sure script is run as root
[ "`whoami`" = "root" ] || ( echo "Should be run as root" && exit 1 )

# install lxd if necessary do not install lxc-utils
command -V lxd &>/dev/null && echo "lxd is installed" || { echo "Installing lxd..."; snap install lxd; }

# run lxd init --auto if no lxdbr0 interface exists
if ip a show lxdbr0 &>/dev/null; then
        echo "lxdbr0 interface exists"
else
        echo "Configuring LXD"
        lxd init --auto
fi 

# launch a container running Ubuntu 20.04 server named COMP2101-S22 if necessary
if lxc list | grep COMP2101-S22 &>/dev/null; then
    echo "COMP2101-S22 container exists"
else
        echo "Launching container COMP2101-S22"; 
        lxc launch images:ubuntu/20.04/default/amd64   COMP2101-S22; 
fi


# add or update the entry in /etc/hosts for hostname COMP2101-S22
# with the container’s current IP address if necessary
IPaddress=$(lxc list COMP2101-S22 -c 4 | grep eth | awk '{print $2}')
# Delete the current IP address and add new one
sed -i '/COMP2101-S22/d' /etc/hosts && echo "$IPaddress COMP2101-S22" | tee -a /etc/hosts &>/dev/null && echo "Updated host file"

# install Apache2 in the container if necessary
if lxc exec COMP2101-S22 -- sh -c 'command -v apache2 &>/dev/null'; then
        echo "Apache is installed in the container"
else
        echo "Installing Apache..."
        lxc exec COMP2101-S22 -- sh -c 'sudo apt-get update && sudo apt-get install -y apache2 l && echo "Apache2 has been installed!" || ( echo "Error installing Apache"; exit 1; )'
fi

# retrieve the default web page from the container’s web service with curl 
# notify the user of success or failure
if curl --silent http://COMP2101-S22 &>/dev/null;then
        echo "Apache is working"
else
        echo "Could not get web page"
fi
