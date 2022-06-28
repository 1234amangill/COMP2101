#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this example

myname="$USER"
hostname=`hostname`
currentdate=`date +"%A %l:%M %p"`
day=`date +"%A"`

if [[  $day == "Monday" ]];
then
	title="adventurous"
elif [[  $day == "Tuesday" ]] ;
then
	title="extroverted"
elif [[  $day == "Wednesday" ]]; 
then
	title="gregarious"
elif [[  $day == "Thursday" ]] ;
then
	title="talkative"
elif [[  $day == "Friday" ]] ;
then
	title="thoughful"
elif [[  $day == "Saturday" ]]; 
then
	title="enthusiastic"
else
	title ="sensible"
fi

###############
# Main        #
###############
cat <<EOF
Welcome to planet $hostname, "$title $myname!"
It is  $currentdate
EOF
