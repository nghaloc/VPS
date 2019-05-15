========================================================================================

Redis Cache

========================================================================================

#url: https://linuxize.com/post/how-to-install-and-configure-redis-on-centos-7/

sudo yum install epel-release yum-utils
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi

sudo yum install redis
sudo systemctl start redis
sudo systemctl enable redis
sudo systemctl status redis

#php check redis
<?php
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);

echo $redis->ping();

#output -----
+PONG

# Done - successfull #