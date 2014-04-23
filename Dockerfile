# adapted from https://github.com/tutumcloud/tutum-docker-mysql
#
# building
#
# cd imightbeinatree-docker-mysql
# docker build -t imightbeinatree/mysql-multi2 .
#
# running currently requires that you pass environment variables
#
# optional (required however if the "setup" variable is set to "master" or "slave"):
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
# docker run -d -p 3306:3306 -e "dbname=example_db" -e "slaving_username=suser" -e "slaving_password=spassword" -e "setup=master"  imightbeinatree/mysql
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

ADD config_files/apt.conf.d_90forceyes /etc/apt/apt.conf.d/90forceyes

# install python-software-properties (so you can do add-apt-repository)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q software-properties-common
# add repository so we can do mysql 5.6
RUN add-apt-repository ppa:ondrej/mysql-5.6
RUN apt-get update
# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server-5.6 pwgen

# Add image configuration and scripts
ADD bash_scripts/start.sh /start.sh
ADD bash_scripts/run.sh /run.sh
ADD bash_scripts/start_slaving.sh /start_slaving.sh
ADD bash_scripts/create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD bash_scripts/create_db.sh /create_db.sh
ADD bash_scripts/master_configure.sh /master_configure.sh
ADD bash_scripts/slave_configure.sh /slave_configure.sh
ADD bash_scripts/grant_slave_permission.sh /grant_slave_permission.sh
ADD bash_scripts/import_sql.sh /import_sql.sh
RUN chmod 755 /*.sh
ADD config_files/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD config_files/my.cnf /etc/mysql/conf.d/my.cnf
ADD config_files/master_my.cnf /master_my.cnf
ADD config_files/slave_my.cnf /slave_my.cnf
ADD example_db.sql /example_db.sql

# expose standard mysql port
EXPOSE 3306

# default command - runs shell script controller
CMD ["/run.sh"]