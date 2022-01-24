#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

# Fix permissions warning in Meteor >=1.4.2.1 without breaking
# earlier versions of Meteor with --unsafe-perm or --allow-superuser
# https://github.com/meteor/meteor/issues/7959
export METEOR_ALLOW_SUPERUSER=true

cd $APP_SOURCE_DIR

# Owner of /opt/nodejs and /opt/meteor has to be node to enable correct global installation
chown -R node:node /opt/nodejs /opt/meteor
# Enabling implicit installation of fibers
sudo su - node -s /bin/bash -c 'npm install --global node-gyp'

#download wget
apt-get -y update
apt-get -y install  curl wget unzip

# 
env 

# Install app deps
printf "\n[-] Running npm install in app directory...\n\n"
meteor npm install

# build the bundle
printf "\n[-] Building Meteor application...\n\n"
mkdir -p $APP_BUNDLE_DIR
meteor build --directory $APP_BUNDLE_DIR

printf "\nStarting mongo for tests\n\n"
mongod --storageEngine=wiredTiger > /dev/null 2>&1 &
printf "\nRunning meteor CI tests docker\n\n"

export ROOT_URL=http://$(hostname -f):3000
meteor npm run testonce:docker

# run npm install in bundle
printf "\n[-] Running npm install in the server bundle...\n\n"
cd $APP_BUNDLE_DIR/bundle/programs/server/

meteor npm install --production

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh

# change ownership of the app to the node user
chown -R node:node $APP_BUNDLE_DIR
