========================================================================================

Nginx // Engine X

========================================================================================

yum -y update

sudo yum install yum-utils -y

nano /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key

sudo yum install nginx -y

systemctl enable nginx

systemctl start nginx

test on browser
http://IP

Output::
Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

For online documentation and support please refer to nginx.org.
Commercial support is available at nginx.com.

Thank you for using nginx.

DONE