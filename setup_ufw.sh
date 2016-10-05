#!/bin/bash

# @docs
# man ufw
# man ufw-framework
# 
# @locations
# /etc/ufw/*.rules
#  
# @links
# https://help.ubuntu.com/community/UFW
# https://gist.github.com/lavoiesl/3740917
# 
# https://bugs.launchpad.net/ubuntu/+source/ufw/+bug/852129
# http://www.tecmint.com/how-to-install-and-configure-ufw-firewall/
# http://www.andrewault.net/2010/04/15/ubuntu-ufw-uncomplicated-firewall-examples/
# https://www.howtoforge.com/tutorial/ufw-uncomplicated-firewall-on-ubuntu-15-04/
# https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-14-04
# 
# http://askubuntu.com/questions/54771/potential-ufw-and-fail2ban-conflicts
# https://blog.vigilcode.com/2011/05/ufw-with-fail2ban-quick-secure-setup-part-ii/
# https://dodwell.us/security/ufw-fail2ban-portscan/
# http://savvyadmin.com/ubuntus-ufw/
set -e

# ss -atunp | xargs -I{} echo {}
setup_defaults()
{ 
  ufw status verbose numbered
  ufw enable
  ufw logging on
  ufw default deny incoming
  ufw default allow outgoing

  ufw allow ssh
  ufw allow http
  ufw allow https
  ufw allow 8080/tcp
  ufw limit ssh
}

check_status()
{
   ufw status verbose numbered
}

secure_outgoing()
{
  # Kill outgoing mail for a specific user
  # iptables -I OUTPUT  1 -p tcp -m tcp --dport 25 -m owner --uid-owner www-data -j DROP
  ufw deny out 25 # kill outgoing mail
  # ufw deny out from any to 192.bad.ip.24
}