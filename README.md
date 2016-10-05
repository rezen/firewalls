# firewalls
This repo holds experiments from trying different firewall abtractions / tools. 
The bash scripts include links and functions that help document usage.

- firehol
- ufw
- firewalld
- nftables

### firehol
Uses a custom firewall config and generates `iptable` rules from that config
with protective defaults. Can be installed on `deb` & `rhel`.

### ufw
A `deb` based tool to simplify interactions with `iptables`

### firewalld
A `rhel` based tool to simplify interactions with `iptables`

### nftables
An eventual replacement of `iptables` which uses `bpf` configs
