# adapted from https://github.com/tutumcloud/tutum-docker-mysql
#
# building
#
# cd imightbeinatree-docker-mysql
# docker build -t imightbeinatree/mysql-multi2 .
#
# running currently requires that you pass environment variables
#
# required:
# dbname - name of the database to be created
#
# optional:
# setup - when "master" it will setup the db as a master database server
# setup - when "slave" it will setup the db as a slave database server
#
# required with setup=master
# slaving_username - username for a slave mysql server to connect to this master
# slaving_password - password for a slave mysql server to connect to this master
#
# master example:
# docker run -d -p 3306:3306 -e "dbname=example_db" -e "slaving_username=suser" -e "slaving_password=spassword" -e "setup=master"  imightbeinatree/mysql-multi 
#
#
# required with setup=slave
# slaving_username - username for a slave mysql server to connect to this master
# slaving_password - password for a slave mysql server to connect to this master
# bin_file
# bin_position
# 
# when setting up a slave you are also required to link the master db container with the name masterdb
# the master db should be on the actually exposed port 3306
# so that the environment variable MASTERDB_PORT_3306_TCP_ADDR will exist
#
# linked container slave example: 
# our master db is in a docker container named goofy_wright
# docker run -d -p 3306 --link goofy_wright:masterdb -e "dbname=example_db" -e "slaving_username=suser" -e "slaving_password=spassword" -e "setup=slave" -e "bin_file=mysql-bin.000001" -e "bin_position=423"  imightbeinatree/mysql
#

FROM ubuntu:saucy
MAINTAINER Michael Orr <michael@cloudspace.com>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD master_my.cnf /master_my.cnf
ADD slave_my.cnf /slave_my.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD create_db.sh /create_db.sh
ADD master_configure.sh /master_configure.sh
ADD slave_configure.sh /slave_configure.sh
ADD grant_slave_permission.sh /grant_slave_permission.sh
ADD start_slaving.sh /start_slaving.sh
ADD import_sql.sh /import_sql.sh
RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/run.sh"]