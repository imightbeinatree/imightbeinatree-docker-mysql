#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
  /create_mysql_admin_user.sh
fi

if [ "$setup_master" == "y" ]; then
  if [ ! -f /.master_configured ]; then
    /master_configure.sh
  fi
fi

if [ ! -f /.db_created ]; then
  /create_db.sh $dbname
fi

if [ "$setup_master" == "y" ]; then
  if [ ! -f /.slave_permission_granted ]; then
    /grant_slave_permission.sh $slaving_username $slaving_password
  fi
fi

exec supervisord -n
