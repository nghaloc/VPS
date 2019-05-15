========================================================================================

VirtualHost - Nginx Server Block

========================================================================================

mkdir -p /var/www/domain.com/{public_html,.well-known}
ls -l -a /var/www/domain.com/
chown -R nginx:nginx /var/www/domain.com/{public_html,.well-known}
nano /var/www/domain.com/public_html/index.html
<h1>Tao Virtualhost Thanh cong</h1>


================================================================
Standard Nginx Config File - Full SSL + Caching + Compress
================================================================

nano /etc/nginx/conf.d/domain.com.conf

server {
   listen   80;
   # Enable SSL
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

   server_name   domain.com www.domain.com;
   root    /var/www/domain.com/public_html;
   index index.php index.html index.htm;

   location / {
      #try_files  $uri $uri/ /index.php?q=$uri&args;
      try_files $uri $uri/ /index.php?_url=$uri&$args;
   }

   # Let's Encrypt
   location ~ /.well-known {
        allow all;
   }

   location /phpmyadmin {
      auth_basic "Admin Login";
      auth_basic_user_file /etc/nginx/pma_pass;
   }

   error_page 404 /404.html;
   error_page 500 502 503 504 /50x.html;
   location = /50x.html {
        root /var/www/domain.com/public_html;
   }

   # Create FastCGI Cache
   set $no_cache 0;
    if ($request_uri ~* "/(wp-admin/)")
    {
    set $no_cache 1;
    }
    #Don't cache POST requests
    if ($request_method = POST)
    {
      set $no_cache 1;
    }
    #Don't cache if the URL contains a query string
    if ($query_string != "")
    {
      set $no_cache 1;
    }
    if ($http_cookie = "PHPSESSID")
    {
            set $no_cache 1;
    }
    location ~ \.php$ {
      try_files $uri =404;
      fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include fastcgi_params;
      fastcgi_param HTTP_X_REAL_IP $remote_addr;

      # Cấu hình FastCGI Cache cho PHP Scripts
      fastcgi_cache semnixcache;
      fastcgi_cache_valid 200 60m; # Chỉ cache lại các response có code là 200 OK trong 60 phút
      fastcgi_cache_methods GET HEAD; # Áp dụng với các phương thức GET HEAD
      add_header X-Fastcgi-Cache $upstream_cache_status; # Thêm vào header trạng thái cache MISS (chưa cache), HIT (đã cache)
      fastcgi_cache_bypass $no_cache; # no_cache=1 không lấy dữ liệu từ cache với request_uri bắt đầu bằng wp-admin.
      fastcgi_no_cache $no_cache; # Khi no_cache=1 đồng thời cũng không lưu cache với response trả về.
      add_header X-Semnix-Cache $upstream_cache_status;
   }

   #Compress file
   location ~* \.(js|css|png|jpg|jpeg|gif|ico|wmv|3gp|avi|mpg|mpeg|mp4|flv|mp3|mid|wml|swf|pdf|doc|docx|ppt|pptx|zip)$ {
        expires 365d;
    }
}

sudo systemctl restart nginx mariadb php-fpm
