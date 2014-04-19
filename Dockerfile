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
# master_db_ip - ip address of master db
# bin_file
# bin_position
# db_dump_file - full path to db dump file on the box the docker container is running on

FROM ubuntu:saucy
MAINTAINER Michael Orr <michael@cloudspace.com>

# Install packages
RUN add-apt-repository ppa:ondrej/mysql-5.6
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server-5.6 pwgen

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
ADD example_db.sql /example_db.sql
RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/run.sh"]