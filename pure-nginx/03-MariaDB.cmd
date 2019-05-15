========================================================================================

MariaDB

========================================================================================

# Check version
http://yum.mariadb.org
current version: mariadb 10.4.4

nano /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4.4/centos7-amd64/
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

sudo yum makecache fast

sudo yum install mariadb-server mariadb -y

rpm -qi MariaDB-server

systemctl enable --now mariadb

sudo systemctl status mariadb

mysql_secure_installation
#follow it
#[enter] n [enter] Y [enter] [Password] [retype Password] [enter] Y Y Y Y

#check version
mysql -u root -p
[Password]

SELECT VERSION();

QUIT

mysql -V

################# COMMAND ##################

============================================
Create User
============================================
mysql -u root -p

CREATE USER ‘username’@‘localhost' IDENTIFIED BY ‘password’;

GRANT ALL PRIVILEGES ON * . * TO 'username'@'localhost';

FLUSH PRIVILEGES;

exit;

============================================
Create DB name
============================================

CREATE DATABASE db_name;

============================================
Create DB user with DB name created
============================================

CREATE USER ‘user_name’@‘localhost' IDENTIFIED BY ‘password’;

GRANT ALL PRIVILEGES ON db_name . * TO 'user_name'@'localhost';

FLUSH PRIVILEGES;

exit;

============================================

Import SQL

============================================

use db_name;
source /path/to/file_name.sql;

============================================

Show Databse

============================================

show tables;
