#!/bin/bash

#universal
iptables -t filter -A INPUT -s 10.0.2.0/24 -p tcp -m tcp --dport 22 -j ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT



echo
while [ -n "$1" ]
do
case "$1" in
-web) 
echo "Found the -web option"
iptables -t filter -A INPUT -s 10.0.2.0/24 -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -s 10.0.2.0/24 -p tcp -m tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -s db.runalsh.local -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -s db.runalsh.local -p tcp -m tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -s router.runalsh.local -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -s router.runalsh.local -p tcp -m tcp --dport 443 -j ACCEPT
iptables -P FORWARD DROP 
;;
-router) 
echo "Found the -router option" 
iptables -t filter -A INPUT -s 10.0.2.0/24 -p tcp -m tcp --dport 3000 -j ACCEPT
iptables -t filter -A INPUT -p udp -m udp --sport 53 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth3 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth2 -j ACCEPT
iptables -A INPUT -i eth1 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i eth2 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i eth3 -p udp --dport 53 -j ACCEPT
iptables -P FORWARD ACCEPT
;;
-db) 
echo "Found the -db option" 
iptables -t filter -A INPUT -s 10.0.2.0/24 -p tcp -m tcp --dport 5050 -j ACCEPT
iptables -t filter -A INPUT -s 192.168.10.0/24 -p tcp -m tcp --dport 5432 -j ACCEPT
iptables -t filter -A INPUT -s 192.168.10.0/24 -p tcp -m tcp --dport 22 -j ACCEPT
iptables -P FORWARD DROP
;;
-elk) 
echo "Found the -elk option" 
iptables -t filter -A INPUT -s 192.168.10.0/24 -p tcp -m tcp --dport 5044 -j ACCEPT
iptables -t filter -A INPUT -s 10.0.2.0/24 -p tcp -m tcp --dport 5601 -j ACCEPT
iptables -P FORWARD DROP
;;
*) echo "$1 is not an option" ;;
esac
shift
done

#closing
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT







