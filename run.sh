#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
  /create_mysql_admin_user.sh
fi

if [ ! -f /.db_created ]; then
  /create_db.sh $dbname
fi

if [ ! -f /.master_configured ]; then
  sed -i -e "s/master_example_db/$dbname/g" /etc/mysql/conf.d/my.cnf
  touch /.master_configured
fi

if [ ! -f /.slave_permission_granted ]; then
  /grant_slave_permission.sh $slaving_username $slaving_password
fi


exec supervisord -n
