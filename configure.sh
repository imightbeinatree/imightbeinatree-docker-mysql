#!/bin/bash
echo "=> Configuring Files"
sed -i -e "s/master_example_db/$dbname/g" /etc/mysql/conf.d/my.cnf
echo "=> Done!"
touch /.master_configured
