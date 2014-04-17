#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
  /create_mysql_admin_user.sh
fi

if [ ("$setup" == "master") -a (! -f /.master_configured) ]; then
  /master_configure.sh
fi

if [ "$setup" == "slave" -a (! -f /.slave_configured) ]; then
  echo "$MASTERDB_PORT_3306_TCP_ADDR - linked master db addr"
  /slave_configure.sh
fi

if [ ("$dbname" != "") -a (! -f /.db_created) ]; then
  /create_db.sh $dbname
fi

if [ ("$setup" == "master") -a (! -f /.slave_permission_granted) ]; then
  /grant_slave_permission.sh $slaving_username $slaving_password
fi

if [ "$setup" == "slave" -a (! -f /.slaving_started) ]; then
  /start_slaving.sh $slaving_username $slaving_password $bin_file $bin_position
fi

exec supervisord -n
