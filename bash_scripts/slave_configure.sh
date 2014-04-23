#!/bin/bash
echo "=> Configuring Slave DB Files"
sed -i -e "s/example_db/$dbname/g" /slave_my.cnf
mv /slave_my.cnf /etc/mysql/conf.d/my.cnf
echo "=> Done!"
touch /.slave_configured
