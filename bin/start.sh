#!/bin/sh

# Initialise directories and get variables.
env=$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]' | sed 's/ //g')

ln -s /project /$env 2>/dev/null
cd /$env

orgName=$(cat sfdx-project.json | jq -r '.name')

# Authorise the new org if the auth list is empty.
if [ $(sfdx force:auth:list | wc -l) = 4 ]; then
  case "$env" in
    *prod*) orgUrl="https://${orgName}.my.salesforce.com" ;;
    *) orgUrl="https://${orgName}--${env}.my.salesforce.com" ;;
  esac

  sfdx auth:device:login --setdefaultdevhubusername --setalias default-user --instanceurl ${orgUrl}
fi

echo '====================================='
echo '       SFDX Image Started!'
echo '====================================='
sfdx force:org:list --all
/bin/bash