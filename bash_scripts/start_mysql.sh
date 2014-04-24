#!/bin/bash

#echo "=> Starting MySQL Server"
/usr/bin/mysqld_safe > /dev/null 2>&1 &
sleep 5
#echo "   Started with PID $!"
