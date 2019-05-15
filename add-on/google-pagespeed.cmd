========================================================================================

GZip

========================================================================================

#url: https://www.modpagespeed.com/doc/build_ngx_pagespeed_from_source

yum -y update
sudo yum -y install gcc-c++ pcre-devel zlib-devel make unzip libuuid-devel

#[check the release notes for the latest version]

cd /usr/local/src
NPS_VERSION=1.13.35.2-beta
wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
unzip v${NPS_VERSION}.zip
nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
cd "$nps_dir"
NPS_RELEASE_NUMBER=${NPS_VERSION/beta/}
NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
[ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
wget ${psol_url}
tar -xzvf $(basename ${psol_url})  # extracts to psol/

cd /usr/local/src
wget https://www.openssl.org/source/openssl-1.1.1b.tar.gz && tar -xzvf openssl-1.1.1b.tar.gz

NGINX_VERSION=[check nginx's site for the latest version]
NGINX_VERSION=1.16.0
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
nginx -V
./configure ... --with-openssl=/usr/local/src/openssl-1.1.1b --add-module=/usr/local/src/incubator-pagespeed-ngx-1.13.35.2-beta/
make
sudo make install

============================================
ENABLE PAGESPEED 
============================================

nano /etc/nginx/conf.d/pagespeed.conf

# enable ngx_pagespeed
pagespeed on;

pagespeed FileCachePath /var/ngx_pagespeed_cache;

# let's speed up PageSpeed by storing it in the super duper fast memcached
# pagespeed MemcachedThreads 1;
# pagespeed MemcachedServers "localhost:11211";

# disable CoreFilters
pagespeed RewriteLevel PassThrough;

# enable collapse whitespace filter
pagespeed EnableFilters collapse_whitespace;

# enable JavaScript library offload
pagespeed EnableFilters canonicalize_javascript_libraries;

# combine multiple CSS files into one
pagespeed EnableFilters combine_css;

# combine multiple JavaScript files into one
pagespeed EnableFilters combine_javascript;

# remove tags with default attributes
pagespeed EnableFilters elide_attributes;

# improve resource cacheability
pagespeed EnableFilters extend_cache;

# flatten CSS files by replacing @import with the imported file
pagespeed EnableFilters flatten_css_imports;
pagespeed CssFlattenMaxBytes 5120;

# defer the loading of images which are not visible to the client
pagespeed EnableFilters lazyload_images;

# enable JavaScript minification
pagespeed EnableFilters rewrite_javascript;

# enable image optimization
pagespeed EnableFilters rewrite_images;

# pre-solve DNS lookup
pagespeed EnableFilters insert_dns_prefetch;

# rewrite CSS to load page-rendering CSS rules first.
pagespeed EnableFilters prioritize_critical_css;
        
systemctl restart nginx mariadb php-fpm

