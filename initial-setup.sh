apt-get -y purge dbus libx11-6
apt-get -y autoremove

echo "Asia/Hong_Kong" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

apt-get update
apt-get -y upgrade
apt-get -y install build-essential unzip cmake autoconf openssl

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo "/swapfile   none    swap   sw   0   0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

adduser $1
echo "$1    ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$1
chmod 440 /etc/sudoers.d/$1
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
