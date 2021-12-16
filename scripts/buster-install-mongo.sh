#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
    source <(grep INSTALL_MONGO $APP_SOURCE_DIR/launchpad.conf)
fi

printf "\n[-] Installing MongoDB ${MONGO_VERSION}...\n\n"

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4B7C549A058F8B6B

echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list

apt-get update

apt-get install --no-install-recommends -y \
${MONGO_PACKAGE}=$MONGO_VERSION \
${MONGO_PACKAGE}-server=$MONGO_VERSION \
${MONGO_PACKAGE}-shell=$MONGO_VERSION \
${MONGO_PACKAGE}-mongos=$MONGO_VERSION \
${MONGO_PACKAGE}-tools=$MONGO_VERSION

mkdir -p /data/{db,configdb}
chown -R mongodb:mongodb /data/{db,configdb}

rm -rf /var/lib/apt/lists/*
rm -rf /var/lib/mongodb
mv /etc/mongod.conf /etc/mongod.conf.orig
