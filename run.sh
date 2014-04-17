#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
  /create_mysql_admin_user.sh
fi

if [ "$setup" == "master" ]; then
  if [ ! -f /.master_configured ]; then
    /master_configure.sh
  fi
fi

if [ "$setup" == "slave" ]; then
  if [ ! -f /.slave_configured ]; then
    /slave_configure.sh
  fi
fi

if [ ! -f /.db_created ]; then
  /create_db.sh $dbname
fi

if [ "$setup" == "master" ]; then
  if [ ! -f /.slave_permission_granted ]; then
    /grant_slave_permission.sh $slaving_username $slaving_password
  fi
fi

if [ "$setup" == "slave" ]; then
  if [ ! -f /.slaving_started ]; then
    /start_slaving.sh $slaving_username $slaving_password $master_db_ip $bin_file $bin_position
  fi
fi

exec supervisord -n
