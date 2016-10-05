#!/bin/bash

# http://adamantsys.com/node/186
# http://www.floc.net/doc/firehol/html/tutorial.html
# http://bc-dev.net/2008/05/01/configuring-a-simple-firewall/
# https://www.rizvir.com/articles/easy-secure-firewalls-with-firehol/
set -e

main()
{
  if [[ `id -u` -ne 0 ]]
  then
    echo '[!] You need to run this as sudo!'
    return 1
  fi

  if (which apt)
  then
    apt-get update
    apt-get install -y firehol
  else 
    yum install firehol
  fi
}

main
