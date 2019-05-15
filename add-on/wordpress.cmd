========================================================================================

Wordpress

========================================================================================

cd /var/www/domain.com/public_html
chown -R nginx:nginx /var/www/domain.com/public_html
wget https://wordpress.org/latest.zip
unzip latest.zip && mv -v /var/www/domain.com/public_html/wordpress/* /var/www/domain.com/public_html && rm -rf /var/www/domain.com/public_html/wordpress && rm -rf latest.zip
cp wp-config-sample.php wp-config.php ; chmod 644 wp-config.php ; nano wp-config.php