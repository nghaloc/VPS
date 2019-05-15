========================================================================================

Let's Encrypts (SSL Free)

========================================================================================

#url: https://www.techblog.vn/thiet-lap-https-voi-chung-chi-ssl-mien-phi-lets-encrypt-cho-nginx-tren-centos-7

yum -y update
yum install letsencrypt
nano /etc/nginx/conf.d/domain.com.conf
...
   location ~ /.well-known {
        allow all;
   }
...

systemctl restart nginx
check .well-known folder
ls -l -a /var/www/domain.com/
if not
mkdir -p /var/www/domain.com/.well-known
sudo letsencrypt certonly -a webroot --webroot-path=/var/www/domain.com/public_html -d domain.com -d www.domain.com
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/domain.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/domain.com/privkey.pem
   Your cert will expire on 2019-08-09. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

email >> Y >> A >> Y
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048


============================================
Config Nginx server Block
============================================
nano /etc/nginx/conf.d/domain.com.conf

server {
    listen   80;
    listen 443 default_server ssl http2;
    listen [::]:443 default_server ssl http2;
    ssl_certificate     /etc/letsencrypt/live/domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain.com/privkey.pem;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ssl_session_timeout 30m;
    ssl_session_cache shared:SSL:10m;
    

    ssl_protocols TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384';
    ssl_session_cache shared:TLS:2m;
    ssl_buffer_size 8k;
    add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload' always;

    ssl_stapling on;
    ssl_stapling_verify on;

    ssl_trusted_certificate /etc/letsencrypt/live/domain.com/chain.pem;
    resolver 8.8.8.8 8.8.4.4 valid=86400;
    resolver_timeout 10;

    ...
}
============================================
Renew expire SSL
============================================
sudo certbot renew

sudo crontab -e
or
sudo env EDITOR=nano crontab -e

30 0 1 */2 * /usr/bin/letsencrypt renew && /bin/systemctl reload nginx

systemctl restart nginx

#check
https://www.ssllabs.com/ssltest/analyze.html

#fix
Cipher Strength 100d
ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384';

