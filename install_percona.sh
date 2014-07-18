#!/bin/bash

clear

echo “DOWNLOADING PERCONA VER $1”
PERCONA_FILE="percona-server-$1.tar.gz"
PERCONA_ADDRESS="http://www.percona.com/redir/downloads/Percona-Server-5.6/LATEST/source/tarball/$PERCONA_FILE"
PERCONA_FOLDER="percona-server-$1"

wget $PERCONA_ADDRESS
tar zxvf $PERCONA_FILE

echo "INSTALLING PACKAGES: libncurses5-dev libaio-dev libbison-dev"
apt-get -y install libncurses5-dev libaio-dev libbison-dev

groupadd mysql
useradd -r -g mysql mysql

echo "BUILDING PERCONA"
cd $PERCONA_FOLDER
cmake . -DBUILD_CONFIG=mysql_release -DFEATURE_SET=community  -DENABLE_DOWNLOADS=1
make

echo "INSTALLING PERCONA"
make install

cd /usr/local/mysql
chown -R mysql .
chgrp -R mysql .

scripts/mysql_install_db --user=mysql
chown -R root .
chown -R mysql data

cp support-files/mysql.server /etc/init.d/mysql.server
update-rc.d -f mysql.server defaults
