========================================================================================

PHP

========================================================================================

yum install epel-release -y
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install yum-utils -y
yum-config-manager --enable remi-php73
yum install php php-fpm php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd php-pecl-redis php-pecl-memcache php-pecl-memcached php-mbstring php-xml php-pecl-mongodb

module option: php-pecl-apc php-pear php-pdo php-pgsql 

php -v
chown -R root:nginx /var/lib/php
sudo systemctl enable php-fpm
sudo systemctl start php-fpm


============================================
Config php
============================================
@@@@@@@@@@@@@@@@@@@@@@@@@@@
Upload max
@@@@@@@@@@@@@@@@@@@@@@@@@@@

nano /etc/php.ini
cgi.fix_pathinfo=0
upload_max_filesize = 128M
post_max_size = 80M

nano /etc/nginx/nginx.conf
http {
    ...
	client_max_body_size 1024M;
}
systemctl restart nginx mariadb php-fpm
systemctl status nginx mariadb php-fpm

@@@@@@@@@@@@@@@@@@@@@@@@@@@
Conver apache --> Nginx
@@@@@@@@@@@@@@@@@@@@@@@@@@@

nano /etc/php-fpm.d/www.conf       
user = apache to user = nginx
group = apache to group = nginx
listen.owner = nobody to listen.owner = nginx
listen.group = nobody to listen.group = nginx
And, lastly, under ;listen = 127.0.0.1:9000 add this line:
listen = /var/run/php-fpm/php-fpm.sock
systemctl restart php-fpm

@@@@@@@@@@@@@@@@@@@@@@@@@@@
backup default.conf of nginx
@@@@@@@@@@@@@@@@@@@@@@@@@@@

cd /etc/nginx/conf.d/
mv default.conf default.conf.bak

@@@@@@@@@@@@@@@@@@@@@@@@@@@
Confige default.conf
@@@@@@@@@@@@@@@@@@@@@@@@@@@

nano /etc/nginx/conf.d/default.conf 
# nginx 1.12.2 (tham khao chuan)+ nginx 1.16.0 - ok good
server {
    listen   80;
    server_name  IP_SERVER;    # note that these lines are originally from the "location /" block
    root   /var/www/html;
    index index.php index.html index.htm;    
    location / {
        #try_files $uri $uri/ /index.php?q=$uri&$args;
        try_files $uri $uri/ /index.php?_url=$uri&$args;
    }
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /var/www/html;
    }    
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

============================================
Check php
============================================
nano /var/www/html/info.php
<?php
  phpinfo();
  phpinfo(INFO_MODULES);
?>
sudo systemctl restart nginx mariadb php-fpm

