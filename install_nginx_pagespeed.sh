#!/bin/bash

clear

echo “DOWNLOADING NGINX VER $1”
NGINX_FILE="nginx-$1.tar.gz"
NGINX_ADDRESS="http://nginx.org/download/$NGINX_FILE"
NGINX_FOLDER="nginx-$1"
wget $NGINX_ADDRESS
tar zxvf $NGINX_FILE

echo "DOWNLOADING PCRE LIB VER $2"
PCRE_FILE="pcre-$2.tar.gz"
PCRE_ADDRESS="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PCRE_FILE"
PCRE_FOLDER="pcre-$2"
wget $PCRE_ADDRESS
tar zxvf $PCRE_FILE

echo "DOWNLOADING ZLIB VER $3"
ZLIB_FILE="zlib-$3.tar.gz"
ZLIB_ADDRESS="http://zlib.net/$ZLIB_FILE"
ZLIB_FOLDER="zlib-$3"
wget $ZLIB_ADDRESS
tar zxvf $ZLIB_FILE

echo "DOWNLOADING PAGESPEED VER $4"
PS_FILE="release-$4-beta.zip"
PS_ADDRESS="https://github.com/pagespeed/ngx_pagespeed/archive/$PS_FILE"
PS_FOLDER="ngx_pagespeed-release-$4-beta"

wget $PS_ADDRESS
unzip $PS_FILE
cd $PS_FOLDER
PSOL="https://dl.google.com/dl/page-speed/psol/$4.tar.gz"
wget $PSOL
tar zxvf $4.tar.gz

cd ~

echo "INSTALLING PACKAGES: libssl-dev"
apt-get -y install libssl-dev

echo "BUILDING NGINX"
cd $NGINX_FOLDER
./configure --user=www-data --group=www-data --with-http_ssl_module --with-pcre=../$PCRE_FOLDER --with-zlib=../$ZLIB_FOLDER --add-module="$HOME/ngx_pagespeed-release-$4-beta" --with-http_spdy_module --with-file-aio --with-http_gzip_static_module 
make

echo "INSTALLING NGINX"
make install
make clean
cd ..
wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
chmod +x /etc/init.d/nginx
sudo update-rc.d -f nginx defaults

