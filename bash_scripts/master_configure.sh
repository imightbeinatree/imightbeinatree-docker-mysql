#!/bin/bash
echo "=> Configuring Master DB Files"
sed -i -e "s/example_db/$dbname/g" /master_my.cnf
mv /master_my.cnf /etc/mysql/conf.d/my.cnf
echo "=> Done!"
touch /.master_configured
