========================================================================================

phpMyadmin

========================================================================================

cd
yum install epel-release -y
yum install phpmyadmin -y
sudo ln -s /usr/share/phpMyAdmin /var/www/html
chown -R root:nginx /etc/phpMyAdmin/
systemctl restart php-fpm
cd /var/www/html
sudo mv phpMyAdmin phpmyadmin (rename phpMyadmin to phpadmin )
ls -l

http://IP_Server/phpmyadmin

============================================
Setting up a Web Server Authentication Gate
============================================

openssl passwd
(type Option), ex: Blablabla
output ---
Verifying - Password: 
sxuLW6PlBIxU.

sudo nano /etc/nginx/pma_pass
demo:sxuLW6PlBIxU.  (username (custom))

sudo nano /etc/nginx/conf.d/default.conf
server {
    . . .

    location / {
        #try_files $uri $uri/ /index.php?q=$uri&$args;
        try_files $uri $uri/ /index.php?_url=$uri&$args;
    }

    location /phpmyadmin {
        auth_basic "Admin Login";
        auth_basic_user_file /etc/nginx/pma_pass;
    }

    . . .
}

sudo systemctl restart nginx

http://IP_Server/phpadmin
username: demo
password: Blablabla
===> Login phpmyadmin continue

fix: The configuration file now needs a secret passphrase (blowfish_secret).
chown -R root.nginx /etc/phpMyAdmin/