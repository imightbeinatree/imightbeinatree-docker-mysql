#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <dbname> <db_dump_file>"
	exit 1
fi

/start_mysql.sh

echo "=> Importing SQL file"
mysql -uroot $1 < "$2"

/stop_mysql.sh

echo "=> Done!"
