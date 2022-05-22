# Base image
FROM node:18.1.0-slim

# All library versions we want to control.
ARG SFDX_VERSION=7.150.0
ARG SFDX_DELTA_VERSION=5.2.0
ARG VLOCITY_VERSION=1.15.2

# Install all npm libraries
RUN bash -c "npm i -g sfdx-cli@$SFDX_VERSION vlocity@${VLOCITY_VERSION}"

# Install system libraries
RUN apt-get update
RUN apt-get install --assume-yes openjdk-11-jdk-headless jq git rsync

# Install all SFDX plugins
RUN bash -c "sfdx plugins:install sfdx-git-delta@${SFDX_DELTA_VERSION}"

# Clean up the image to keep the image as small as possible
RUN apt-get autoremove --assume-yes
RUN apt-get clean --assume-yes
RUN rm -rf /var/lib/apt/lists/*

# Copy all scripts we want to keep.
COPY bin /bin

# Add aliases
RUN echo 'alias sfdx="/bin/aliases.sh"' >> ~/.bashrc