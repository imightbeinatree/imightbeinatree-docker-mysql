FROM ubuntu:saucy
MAINTAINER Michael Orr <michael@cloudspace.com>

ADD config_files/apt.conf.d_90forceyes /etc/apt/apt.conf.d/90forceyes

# install python-software-properties (so you can do add-apt-repository)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q software-properties-common
# add repository so we can do mysql 5.6
RUN add-apt-repository ppa:ondrej/mysql-5.6
RUN apt-get update
# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server-5.6 pwgen openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:updog' | chpasswd
ADD config_files/ssh_config /etc/ssh/ssh_config
ADD config_files/sshd_config /etc/ssh/sshd_config
RUN sudo service ssh restart

# Add image configuration and scripts
ADD bash_scripts/create_db.sh /create_db.sh
ADD bash_scripts/create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD bash_scripts/grant_slave_permission.sh /grant_slave_permission.sh
ADD bash_scripts/import_sql.sh /import_sql.sh
ADD bash_scripts/master_configure.sh /master_configure.sh
ADD bash_scripts/run.sh /run.sh
ADD bash_scripts/start_mysql.sh /start_mysql.sh
ADD bash_scripts/start_mysql_daemon.sh /start_mysql_daemon.sh
ADD bash_scripts/stop_mysql.sh /stop_mysql.sh
ADD bash_scripts/start_slaving.sh /start_slaving.sh
ADD bash_scripts/slave_configure.sh /slave_configure.sh
RUN chmod 755 /*.sh

ADD config_files/master_my.cnf /master_my.cnf
ADD config_files/my.cnf /etc/mysql/conf.d/my.cnf
ADD config_files/slave_my.cnf /slave_my.cnf
ADD config_files/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# expose standard mysql port
EXPOSE 3306

# default command - runs shell script controller
CMD ["/run.sh"]