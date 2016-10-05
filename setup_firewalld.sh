#!/bin/bash

# @locations
# /etc/sysconfig/firewalld
# /var/log/firewalld
# 
# @links
# http://www.cyberciti.biz/tips/linux-iptables-examples.html
# https://www.certdepot.net/rhel7-get-started-firewalld/
# http://www.win.tue.nl/~vincenth/ssh_rate_limit_firewalld.htm
# http://ktaraghi.blogspot.com/2013/10/what-is-firewalld-and-how-it-works.html
# http://www.tejasbarot.com/2014/08/05/rhel-7-centos-7-how-to-get-started-with-firewalld/
# https://www.linode.com/docs/security/firewalls/introduction-to-firewalld-on-centos
# https://www.digitalocean.com/community/tutorials/how-to-migrate-from-firewalld-to-iptables-on-centos-7
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7
#
# https://fedoraproject.org/wiki/Fail2ban_with_FirewallD
# https://krash.be/node/28
# http://blog.iopsl.com/fail2ban-on-centos-7-to-protect-ssh-part-i/
# https://eatpeppershothot.blogspot.com/2015/07/setting-up-fail2ban-on-centos-7-with.html
# https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture
set -e

setup_defaults()
{ 
  systemctl start firewalld.service
  firewall-cmd --state
  firewall-cmd --zone=public --add-service={http,https,ssh} --permanent
  firewall-cmd --zone=public --add-service={http,https,ssh}
  firewall-cmd --zone=public --add-port=8080/tcp
}

check_status()
{
  firewall-cmd --get-default-zone
  firewall-cmd --get-active-zones
  firewall-cmd --list-all
}

secure_outgoing()
{
  # Kill outgoing mail for a specific user
  # iptables -I OUTPUT  1 -p tcp -m tcp --dport 25 -m owner --uid-owner www-data -j DROP
  firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 999 -p tcp --dport 25 -j DROP
}