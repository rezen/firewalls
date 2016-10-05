#!/bin/bash

# https://home.regit.org/netfilter-en/nftables-quick-howto/
# https://linux-audit.com/differences-between-iptables-and-nftables-explained/
# http://linoxide.com/firewall/configure-nftables-serve-internet/
# https://wiki.archlinux.org/index.php/nftables
# https://wiki.nftables.org/wiki-nftables/index.php/Main_Page

set -e
set -o errtrace

check_apt()
{
	apt-cache search nftable
}

install_deps()
{
	sudo apt-get install -y libmnl0 libmnl-dev git autoconf libtool pkg-config \
	flex bison libgmp3-dev libreadline6-dev autogen
}

install_libnftnl()
{
	if (which ldconfig) then
		echo '[i] ldconfig is already installed'
		return 0
	fi

	echo '[i] Starting to install ldconfig'

	cd /opt/
	
	if [ ! -d /opt/libnftnl ]; then
		git clone git://git.netfilter.org/libnftnl
	fi
	
	cd libnftnl
	sh autogen.sh
	./configure
	make
	make install
	ldconfig
}

install_nftables()
{
	if (which nft) then
		echo '[i] nft is already installed'
		return 0
	fi

	echo '[i] Starting to install nft'

	cd /opt/

	if [ ! -d /opt/nftables ]; then
		git clone git://git.netfilter.org/nftables
	fi

	cd nftables
	sh autogen.sh
	./configure
	make
	make install
}

validate_install()
{
	which nft

	# Some confs are stored here
	#  /usr/local/etc/nftables/
	
	nft add table filter
	nft -f /opt/nftables/files/nftables/ipv4-nat
	nft -f /opt/nftables/files/nftables/ipv4-filter
	nft -f /opt/nftables/files/nftables/ipv4-mangle
	nft -f /opt/nftables/files/nftables/ipv6-nat
	nft -f /opt/nftables/files/nftables/ipv6-filter
	nft -f /opt/nftables/files/nftables/ipv6-mangle

	# nft -f /opt/nftables/files/nftables/inet-filter

	
	# nft add rule filter input ct state related,established accept
	# nft insert rule filter input tcp port 22 accept
}

validate_compatibility()
{
	local version=$(uname -r | cut -d'.' -f1-2)
	local version_major=$(uname -r | cut -d'.' -f1)

	if !(modinfo nf_tables) then
		echo '[!] Kernel version does not have nftables module at the ready'
		return 1
	fi

	if [ $version_major -lt 3 ]; then
		echo '[!] Kernel version is older than suggested'
		return 1
	fi

	if [ "$version" == '3.13' ]; then
		echo '[!] Tread carefully, your kernel is the minimum version suggested!'
	fi

	echo '[i] Kernel supports nftables ... onward!'
	
	return 0
}

main()
{
	validate_compatibility
	install_deps
	install_libnftnl
	install_nftables
	validate_install
}

handle_error()
{
  echo "[failed][$0] line $1, exit code $2"
  exit $2
}

trap 'handle_error $LINENO $?' ERR 

main
