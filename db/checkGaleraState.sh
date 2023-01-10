#!/bin/bash

echo "Enter your MySQL user"
read MYSQL_USER

echo "Enter your MySQL password"
stty -echo
read MYSQL_PASSWD
stty echo

STATUS=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWD -N -s -e "show status like 'wsrep_ready';" | awk '{print $2}')
SIZE=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWD -N -s -e "show status like 'wsrep_cluster_size' ;" | awk '{print $2}' | sed -n '2p')

if [[ ${STATUS} = "ON" ]] ; then
	if [[ ${SIZE} -lt 2 ]] ; then
        	echo "Split-brain!"
	else
		echo "Galera is perfectly working"
	fi
else
        echo "The replication is NOT working"
fi
