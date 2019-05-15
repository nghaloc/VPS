========================================================================================

Nginx Caching

========================================================================================

#url: https://www.thuysys.com/toi-uu/tim-hieu-caching-va-cach-tang-toc-website-tren-nginx.html

nano /etc/nginx/nginx.conf

#copy fastcgi_cache_xxx code to:
http { 
    ... 
    # /etc/nginx/cache : Đường dẫn đến thư mục chứa cache
    # levels: phân cấp tên thư mục chứa cache, ví dụ: /cache/c/ch (cái này tự động tạo ra)
    # keys_zone: tên vùng chứa cache
    # max_size: kích cỡ file cache
    # inactive: sau 60m (60 phút) không hoạt động sẽ xoá.
    fastcgi_cache_path /etc/nginx/cache levels=1:2 keys_zone=semnixcache:10m max_size=1000m inactive=60m;
    fastcgi_cache_key "$scheme$request_method$host$request_uri";
}

# config block server
server { ... 

    # Không lưu cache khi truy cập khu vực quản trị wordpress.
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
    # Cấu hình FastCGI Cache cho PHP Scripts
    location ~ .php$ {
    try_files $uri =404;
    fastcgi_cache semnixcache; #semnixcache được tạo từ fastcgi trong http trên.
    fastcgi_cache_valid 200 60m; # Chỉ cache lại các response có code là 200 OK trong 60 phút
    fastcgi_cache_methods GET HEAD; # Áp dụng với các phương thức GET HEAD
    add_header X-Fastcgi-Cache $upstream_cache_status; # Thêm vào header trạng thái cache MISS (chưa cache), HIT (đã cache)
    fastcgi_cache_bypass $no_cache; # no_cache=1 không lấy dữ liệu từ cache với request_uri bắt đầu bằng wp-admin.
    fastcgi_no_cache $no_cache; # Khi no_cache=1 đồng thời cũng không lưu cache với response trả về.
    add_header X-Semnix-Cache $upstream_cache_status;

    # Kết nối fastcgi_pass với php-fpm
    fastcgi_pass unix:/var/run/php-fpm/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    include fastcgi_params;
    fastcgi_param HTTP_X_REAL_IP $remote_addr;
    }
    # CẤU HÌNH BROWSER CACHE (STATIC CACHE)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|wmv|3gp|avi|mpg|mpeg|mp4|flv|mp3|mid|wml|swf|pdf|doc|docx|ppt|pptx|zip)$ {
        expires 365d;
        access_log off;
    }
}

============================================
#Config auto caching
============================================
nano /etc/fstab
tmpfs /etc/nginx/cache tmpfs defaults,size=100M 0 0

============================================
#view caching
============================================
ls -l /var/ngx_pagespeed_cache/
ls -l /etc/nginx/cache/

============================================
#remove caching
============================================
rm -rf /var/ngx_pagespeed_cache/*
rm -rf /etc/nginx/cache/*
systemctl restart nginx

============================================
#php xoá cache url
============================================
nano /var/www/sufalo.com/public_html/purge.php

<!DOCTYPE html>
<html>
<head>
    <title>Purge Caching Nginx</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <form method="POST">
        URL: <input type="text" name="url" value=""/> <br/>
        <input type="submit" name="form_click" value="Xoá cache"/><br/>
        <?php
            if (isset($_POST['form_click'])){
                $cache_path = '/etc/nginx/cache/';
                $url = parse_url($_POST['url']);
                if(!$url)
                {
                    echo 'Invalid URL entered';
                    die();
                }
                $scheme = $url['scheme'];
                $host = $url['host'];
                $requesturi = $url['path'];
                $hash = md5($scheme.'GET'.$host.$requesturi);
                $res = (unlink($cache_path . substr($hash, -1) . '/' . substr($hash,-3,2) . '/' . $hash));
                if ($res == 1) {
                echo 'OK Xoá xong';
                } else { echo 'Chưa cache'; }
            }
        ?>
        </form>
</body>
</html>

