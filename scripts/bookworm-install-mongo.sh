#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
    source <(grep INSTALL_MONGO $APP_SOURCE_DIR/launchpad.conf)
fi

printf "\n[-] Installing MongoDB ${MONGO_VERSION}...\n\n"

# curl https://pgp.mongodb.com/server-8.0.asc | gpg --import for the hash
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 41DE058A4E7DCA05
echo "MongoDB asc"
wget -O ./mongodb.asc https://pgp.mongodb.com/server-8.0.asc
echo "Generate keyring"
gpg --no-default-keyring --keyring ./mongodb_keyring.gpg --import ./mongodb.asc
echo "Generate gpg"
gpg --no-default-keyring --keyring ./mongodb_keyring.gpg --export > ./mongodb.gpg
sudo mkdir -p /etc/apt/keyrings
sudo mv ./mongodb.gpg ./mongodb.asc /etc/apt/keyrings/

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mongodb.asc] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list

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
