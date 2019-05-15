# UPDATE OS
yum -y update

# CÀI HOCVPS SCRIPTS
curl -sO https://hocvps.com/install && bash install

# CÀI PHALCON MODULE (SỬ DỤNG CHO PHALCON FRAMEWORK)
php -i
yum install php-phalcon

# CÀI MEMCACHED MODULE
yum install memcached
systemctl restart memcached
systemctl restart php-fpm
yum install php-memcache
yum install memcached
yum install php-memcached
systemctl restart memcached
systemctl restart php-fpm

# CÀI IMAGEMAGICK MODULE
yum install ImageMagick
yum install php-imagick
service php-fpm restart

# CHECK MODULE
php -m
