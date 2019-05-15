========================================================================================

Centos 7

========================================================================================

Deloy and install centos 7 on VPS
I used Vultr VPS (until now)

========================================================================================

SWAP

========================================================================================

sudo dd if=/dev/zero of=/swaploc bs=1M count=2048
ls -lh /swaploc
sudo chmod 600 /swaploc
sudo mkswap /swaploc
sudo swapon /swaploc
sudo swapon -s
free -m
sudo sysctl vm.swappiness=10
echo "/swaploc   swap    swap    sw  0   0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf
shutdown -r now

========================================================================================

CSF 

========================================================================================

yum install wget perl-libwww-perl.noarch perl-Time-HiRes -y
cd /usr/src/
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh
cd /usr/local/csf/bin/
perl csftest.pl
systemctl stop firewalld
systemctl disable firewalld
cd /etc/csf/
nano csf.conf
TESTING = "0"
TCP_IN 22 -> dif port
TCP_OUT 22 -> dif port
systemctl start csf
systemctl start lfd
systemctl enable csf
systemctl enable lfd
csf -l

# Disable SELINUX
nano /etc/selinux/config
SELINUX=disabled
sestatus

# Change Port SSH
nano /etc/ssh/sshd_config
PORT 14190
systemctl restart sshd
shutdown -r now

# command
csf -s 	Start the firewall (enable the firewall rules):
csf -f Flush/Stop the firewall rules.
csf -r Reload the firewall rules.
csf -a 192.168.1.109 Allow an IP and add it to csf.allow.
csf -ar 192.168.1.109 Remove and delete an IP from csf.allow.
csf -d 192.168.1.109 Deny an IP and add to csf.deny:
csf -dr 192.168.1.109 Remove and delete an IP from csf.deny.
csf -df Remove and Unblock all entries from csf.deny.
csf -g 192.168.1.110 Search for a pattern match on iptables e.g : IP, CIDR, Port Number

# fix restart sshd failed
/etc/selinux/config
SELINUX=disabled
sestatus
shutdown -r now
