# SFDX CLI

## Summary

This is a docker image to help streamline the process of working with the SFDX cli on a per-project basis. It works by analysing the sfdx-project.json and authenticates to the required environment.

What does the future like?

- Custom plugins could be added to the SFDX cli
- Generation of better metadata
- Interactions with orgs
- ...etc

# How-To

1. Install and start docker
2. Copy sfdx-start.bat to your local project
3. Set the name in the sfdx-project.json to be the name of your org
4. Run sfdx-start.bat

## Building
```shell
# Build the contents of the Dockerfile and tag it as the latest, and the version.
docker build . -t zabroseric/sfdx-cli:{version} -t zabroseric/sfdx-cli:latest

# Push the image to dockerhub to be utilised by the pipeline.
docker push zabroseric/sfdx-cli -a
```