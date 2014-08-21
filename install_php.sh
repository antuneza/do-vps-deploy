#!/bin/bash

clear

echo “DOWNLOADING PHP VER $1”
PHP_FILE="php-$1.tar.gz"
PHP_ADDRESS="http://hk1.php.net/get/$PHP_FILE/from/this/mirror"
PHP_FOLDER="php-$1"
wget -O $PHP_FILE $PHP_ADDRESS
tar zxvf $PHP_FILE

echo "DOWNLOADING LIBPNG VER $2"
LIBPNG_FILE="libpng-$2.tar.gz"
LIBPNG_ADDRESS="http://sourceforge.net/projects/libpng/files/libpng16/$2/$LIBPNG_FILE/download"
LIBPNG_FOLDER="libpng-$2"
wget -O $LIBPNG_FILE $LIBPNG_ADDRESS
tar zxvf $LIBPNG_FILE

echo "DOWNLOADING LIBJPG VER $3"
JPG_FILE="jpegsrc.v$3.tar.gz"
JPG_ADDRESS="http://www.ijg.org/files/$JPG_FILE"
JPG_FOLDER="jpeg-$3"
wget -O $JPG_FILE $JPG_ADDRESS
tar zxvf $JPG_FILE

apt-get -y install re2c libbz2-dev libxml2-dev libcurl4-openssl-dev libmcrypt-dev libbison-dev
echo "BUILDING LIBPNG AND PHP"
cd $LIBPNG_FOLDER
./configure
make
make install
cd ..

echo "BUILDING LIBJPEG"

cd $JPG_FOLDER
./configure
make
make install
cd ..

ldconfig

cd $PHP_FOLDER
./configure --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-gd --with-mysqli --with-mysql --with-zlib \
 --without-sqlite3 --enable-gd-native-ttf --enable-mbstring --with-curl --with-mcrypt --with-openssl \
 --without-pdo-sqlite --with-pdo-mysql=mysqlnd --with-mysql-sock --with-bz2 --with-jpeg-dir --enable-soap

make
make test
make install


cp php.ini-production /usr/local/lib/php.ini
cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
update-rc.d -f php-fpm defaults

# INSTALAR EL SERVICIO PHP-FPM
cd ..

