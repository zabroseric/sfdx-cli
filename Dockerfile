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
RUN apt-get install --assume-yes openjdk-11-jdk-headless jq git rsync locales

# Install all SFDX plugins
RUN bash -c "echo y | sfdx plugins:install sfdx-git-delta@${SFDX_DELTA_VERSION}"
RUN bash -c "echo y | sfdx plugins:install sfdx-codescan-plugin@${CODESCAN_VERSION}"

# Clean up the image to keep the image as small as possible
RUN apt-get autoremove --assume-yes
RUN apt-get clean --assume-yes
RUN rm -rf /var/lib/apt/lists/*

# Set the language to be able to read files with special characters.
RUN echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen
RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Disable warnings for the SFDX version.
RUN echo "{}" > /root/.cache/sfdx/version

# Copy all scripts we want to keep.
COPY bin /bin
RUN find /bin -type f -exec chmod +x {} \;

# Add aliases
RUN cat /bin/aliases.sh >> ~/.bashrc