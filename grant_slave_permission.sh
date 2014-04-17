#!/bin/bash

if [ -f /.slave_permission_granted ]; then
	echo "Slave Permissions already granted!"
	exit 0
fi

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <slaving_username> <slaving_password>"
	exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Granting Slave Permission to $1 with password $2"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "GRANT REPLICATION SLAVE ON *.* TO '$1'@'%' IDENTIFIED BY '$2';"
	RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.slave_permission_granted