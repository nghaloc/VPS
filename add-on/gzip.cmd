========================================================================================

GZip

========================================================================================

nano /etc/nginx/nginx.conf

http {

    ....
    ...
    
    ##
    # `gzip` Settings
    #
    #
    gzip on;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_http_version 1.1;
    gzip_min_length 0;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;

}    

systemctl restart nginx mariadb php-fpm
curl -H "Accept-Encoding: gzip" -I http://localhost/info.php
