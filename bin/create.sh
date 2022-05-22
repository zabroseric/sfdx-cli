#!/bin/sh

# Move to the project folder and get the installed dependencies.
cd /project/

# Authorise the new org.
orgName=$(cat sfdx-project.json | jq -r '.name')

case "$ENVIRONMENT" in
  *prod*) orgUrl="https://${orgName}.my.salesforce.com" ;;
  *) orgUrl="https://${orgName}--${ENVIRONMENT}.my.salesforce.com" ;;
esac

sfdx auth:device:login --setdefaultdevhubusername --setalias default-user --instanceurl ${orgUrl}

echo '====================================='
echo '       SFDX Image Started!'
echo '====================================='
sfdx force:org:list --all
/bin/bash