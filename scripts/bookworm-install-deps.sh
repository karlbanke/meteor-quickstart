#!/bin/bash

set -e

printf "\n[-] Installing base OS dependencies...\n\n"

apt-get update -y
apt-get install -y software-properties-common python3-launchpadlib
apt-get update -y

apt-get install -y --no-install-recommends apt-utils sudo curl ca-certificates bzip2 libarchive-tools gcc g++ make build-essential git wget gnupg
apt-get install -y xauth libgtk2.0-0 libasound2 libxtst6 libxss1 libnss3 xvfb

dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"

wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"

export GNUPGHOME="$(mktemp -d)"

echo "bookworm-install-deps.sh: Add keyserver"
#echo "disable-ipv6" >> "$GNUPGHOME"/dirmngr.conf;
gpg -v --keyserver keyserver.ubuntu.com --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
echo "bookworm-install-deps.sh: Verify deps"
gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu

rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc

chmod +x /usr/local/bin/gosu

gosu nobody true

apt-get -y autoremove && apt-get clean