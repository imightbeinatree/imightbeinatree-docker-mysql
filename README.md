imightbeinatree-docker-mysql
==================

adapted from https://github.com/tutumcloud/tutum-docker-mysql

Base docker image to run your choice of:
 1. a standard MySQL 5.6 database server
 2. a master MySQL database server
 3. a slave MySQL database server

Usage
-----

To create the image `imightbeinatree/mysql`, execute the following command on the imightbeinatree-mysql folder:

    docker build -t imightbeinatree/mysql .

To run the image and bind to port 3306:

    docker run -d -p 3306:3306 imightbeinatree/mysql

The first time that you run your container, a new user `admin` with all privileges 
will be created in MySQL with a random password. To get the password, check the logs
of the container by running:

    docker logs <CONTAINER_ID>

You will see an output like the following:

	========================================================================
	You can now connect to this MySQL Server using:

	    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>

	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

In this case, `47nnf4FweaKu` is the password allocated to the `admin` user.

Remember that the `root` user has no password but it's only accesible from within the container.

You can now test your deployment:

    mysql -uadmin -p

Done!


Setting a specific password for the admin account
-------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `MYSQL_PASS` to your specific password when running the container:

    docker run -d -p 3306:3306 -e MYSQL_PASS="mypass" imightbeinatree/mysql

You can now test your deployment:

    mysql -uadmin -p"mypass"


Mounting the database file volume
---------------------------------

In order to persist the database data, you can mount a local folder from the host 
on the container to store the database files. To do so:

    docker run -d -v /path/in/host:/var/lib/mysql imightbeinatree/mysql /bin/bash -c "/usr/bin/mysql_install_db"

This will mount the local folder `/path/in/host` inside the docker in `/var/lib/mysql` (where MySQL will store the database files by default). `mysql_install_db` creates the initial database structure.

Remember that this will mean that your host must have `/path/in/host` available when you run your docker image!

After this you can start your mysql image but this time using `/path/in/host` as the database folder:

    docker run -d -p 3306:3306 -v /path/in/host:/var/lib/mysql imightbeinatree/mysql


Migrating an existing MySQL Server
----------------------------------

In order to migrate your current MySQL server, perform the following commands from your current server:

To dump your databases structure:

    mysqldump -u<user> -p --opt -d -B <database name(s)> > /tmp/dbserver_schema.sql

To dump your database data:

    mysqldump -u<user> -p --quick --single-transaction -t -n -B <database name(s)> > /tmp/dbserver_data.sql

To import a SQL backup which is stored for example in the folder `/tmp` in the host, run the following:

    sudo docker run -d -v /tmp:/tmp imightbeinatree/mysql /bin/bash -c "/import_sql.sh <rootpassword> /tmp/<dump.sql>")

Where `<rootpassword>` is the root password set earlier and `<dump.sql>` is the name of the SQL file to be imported.
  

Creating a Database
----------------------------------

When you run this docker container it will run a MySQL instance. If you would like to go ahead and have a database created for you then you should specify the name of the database as an instance variable called "dbname" when you run the container.

Example Command:

    docker run -d -p 3306:3306 -e "dbname=example_db" imightbeinatree/mysql

Setting up a Master MySQL Server
----------------------------------

In order to setup a master database you must set certain environment variables when you run the container:

1. setup - must be set to the value "master"
2. dbname - this is the database that will be created and binary logging will be turned on for it
3. slaving_username - username that slave database servers will use to connect to this master
4. slaving_password - password that slave database servers will use to connect to this master

Example Command:

    docker run -d -p 3306:3306 -e "dbname=example_db" -e "slaving_username=suser" -e "slaving_password=spassword" -e "setup=master"  imightbeinatree/mysql


Setting up a Slave MySQL Server
----------------------------------

In order to setup a slave database you must set certain environment variables when you run the container:

1. setup - must be set to the value "slave"
2. dbname - this is the database that will be created and setup to slave from the master
3. master_db_ip - ip address of the mysql master
4. slaving_username - username that this slave database servers will use to connect to the master
5. slaving_password - password that this slave database servers will use to connect to the master
6. db_dump_file - database dump file from the master
7. bin_file - bin file that the binary log was using at the time of the supplied database dump
8. bin_position - position in the bin file that the binary log was using at the time of the supplied database dump

note: you likely want to attach storage to get the database dump into the container, see -v

Example Command:

    docker run -d -p 3306 -v /path/to/local/datdump:/data_dumps -e "dbname=example_db" -e "slaving_username=slave_user" -e "slaving_password=password" -e "setup=slave" -e "bin_file=mysql-bin.000003" -e "bin_position=120" -e "master_db_ip=10.0.1.4" -e "db_dump_file=/datadumps/example_db.sql"  imightbeinatree/mysql

note: currently the database dump file is hardcoded to be copied onto the server, this means that before building the image that you plan to run, your dump should be included in the root of this directory and be named example_db.sql.