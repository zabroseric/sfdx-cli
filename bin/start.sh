#!/bin/sh

# Move to the project folder and get the installed dependencies.
cd /project/

echo '====================================='
echo '       SFDX Image Started!'
echo '====================================='
sfdx force:org:list --all
/bin/bash