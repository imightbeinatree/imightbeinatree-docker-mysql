#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
  /create_mysql_admin_user.sh
fi

if [ "$setup" == "master" -a ! -f /.master_configured ]; then
  /master_configure.sh
fi

if [ "$setup" == "slave" -a ! -f /.slave_configured ]; then
  /slave_configure.sh
fi

if [ "$dbname" != "" -a ! -f /.db_created ]; then
  /create_db.sh $dbname
fi

if [ "$setup" == "master" -a ! -f /.slave_permission_granted ]; then
  /grant_slave_permission.sh $slaving_username $slaving_password
fi

if [ "$setup" == "slave" -a ! -f /.slaving_started ]; then
  /start_slaving.sh $dbname $slaving_username $slaving_password $master_db_ip $bin_file $bin_position $db_dump_file
fi

exec supervisord -n
