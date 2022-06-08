#!/bin/sh

# Color variables.
colorOff='\033[0m'
green='\033[0;32m'

echo $green
clear
echo "========================================"
echo "          SFDX Image Started!           "
echo "========================================"
echo $colorOff

# Initialise directories and get variables.
env=$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]' | sed 's/ //g')

# If there are dashes, we're in a sandbox.
ln -s /project /$env 2>/dev/null
ln -s /project /PRODUCTION-$env 2>/dev/null

case "$env" in
  *--*) cd /$env ;;
  *) cd /PRODUCTION-$env ;;
esac

# Authorise the new org if the auth list is empty.
if [ $(sfdx force:auth:list | wc -l) = 4 ]; then
  sfdx auth:device:login --setdefaultdevhubusername --setalias default-user --instanceurl "https://${env}.my.salesforce.com"
fi

sfdx force:org:list --all
/bin/bash