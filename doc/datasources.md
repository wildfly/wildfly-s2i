Datasources Configuration
=========================

There are two types of datasources, internal and external.

Internal Datasource
-------------------

Internal datasources uses one of the drivers that have been provisioned along with the WildFly server. 
The default configuration contains `postgresql` and `mysql` drivers.

To specify internal datasources use the `DB_SERVICE_PREFIX_MAPPING` environment variable. It has the following format 

`<POOLNAME>-<DATABASETYPE>=<PREFIX>`

For example `testa-postgresql=TEST`. The other out of the box valid value for `DATABASETYPE` is `mysql`.

You can create more than one datasource by using a comma separated list of entries, 
e.g: `DB_SERVICE_PREFIX_MAPPING="testa-postgresql=TEST,test2-postgresql=TEST2”`.
One `datasource` or `xa-datasource` entry will be created per entry in the list.

The `PREFIX` is used to determine other relevant datasource variables:

* `POOLNAME_DATABASETYPE_SERVICE_HOST`
	
Defines the database server’s host name or IP address to be used in the datasource’s connection-url property.
Example value: 192.168.1.3

* `POOLNAME_DATABASETYPE_SERVICE_PORT`
	
Defines the database server’s port for the datasource.
Example value: 5432

* `PREFIX_BACKGROUND_VALIDATION`
	
When set to true database connections are validated periodically in a background thread prior to use. 
Defaults to false, meaning the validate-on-match method is enabled by default instead.

* `PREFIX_BACKGROUND_VALIDATION_MILLIS`

Specifies frequency of the validation, in milliseconds, when the background-validation 
database connection validation mechanism is enabled (`PREFIX_BACKGROUND_VALIDATION` variable is set to true). 
Defaults to 10000.

* `PREFIX_CONNECTION_CHECKER`

Specifies a connection checker class that is used to validate connections for the particular database in use.
Example value: `org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker`

* `PREFIX_DATABASE`

Defines the database name for the datasource.
Example value: myDatabase

* `PREFIX_EXCEPTION_SORTER`

Specifies the exception sorter class that is used to properly detect and clean up after fatal database connection exceptions.
Example value: `org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter`

* `PREFIX_JNDI`

Defines the JNDI name for the datasource. Defaults to `java:jboss/datasources/POOLNAME_DATABASETYPE`, 
where `POOLNAME` and `DATABASETYPE` are taken from the triplet described above. 
This setting is useful if you want to override the default generated JNDI name.
Example value: `java:jboss/datasources/test-postgresql`

* `PREFIX_JTA`

Defines Java Transaction API (JTA) option for the non-XA datasource. The XA datasources are already JTA capable by default.
Defaults to true.

* `PREFIX_MAX_POOL_SIZE`
	
Defines the maximum pool size option for the datasource.
Example value: 20

* `PREFIX_MIN_POOL_SIZE`

Defines the minimum pool size option for the datasource.
Example value: 1

* `PREFIX_NONXA`

Defines the datasource as a non-XA datasource. Defaults to false.

* `PREFIX_PASSWORD`

Defines the password for the datasource.
Example value: password

* `PREFIX_TX_ISOLATION`

Defines the `java.sql.Connection transaction` isolation level for the datasource.
Example value: `TRANSACTION_READ_UNCOMMITTED`

* `PREFIX_URL`

Defines connection URL for the datasource.
Example value: `jdbc:postgresql://localhost:5432/postgresdb`

* `PREFIX_USERNAME`

Defines the username for the datasource.
Example value: admin 

Drivers
-------

When adding drivers to WildFly server, you have 2 choices:

* Package your drivers (even datasources) as galleon feature-pack as done in [wildfly-datasources-galleon-pack](https://github.com/wildfly-extras/wildfly-datasources-galleon-pack) 
and include the Galleon feature-pack in your Galleon project.

* Use s2i hooks we are offering that allow you to install driver JBOSS modules and update WildFly configuration.

Drivers deployment and configuration using s2i hooks
----------------------------------------------------

An example of such approach can be found in this [test project](../test/test-app-custom).

To be able to deploy a driver module and configure the jdbc-driver resource in datasources subsystem 
it is necessary to use a special script file called `install.sh`. This file will be invoked during the assemble phase of the S2I process. 

`S2I_IMAGE_SOURCE_MOUNTS` is the environment variable that instructs the S2I process where to find this file. 
This variable will contain a comma-separated list of directories where to find the `install.sh` file.

The following is an example of the content of install.sh script:

```
#!/bin/bash

injected_dir=$1
source /usr/local/s2i/install-common.sh
install_deployments ${injected_dir}/injected-deployments.war
install_modules ${injected_dir}/modules
configure_drivers ${injected_dir}/drivers.env
```

In this example we are using the following methods exposed by `install-common.sh` script. 
This script is available in `/usr/local/s2i` directory of our image. The methods used by the user define `install.sh `script are:

* `install_deployments`: Copy the file passed as an argument to the server deployment directory.
* `install_modules`: Copy all the JBOSS modules in the directory passed as argument to the server modules directory.
* `configure_drivers`: Configure the desired drivers using the environment file passed as an argument.

The `${injected_dir}` in our example will be one of the directories listed in `S2I_IMAGE_SOURCE_MOUNTS` variable that is currently being processed.

The `${injected_dir}/drivers.env` is a file that will contain the environment variables that you want to use to configure drivers. 

The available environment variables that you can configure in this file are:

* `DRIVERS`: It's a comma separated list of driver prefixes. And for each prefix:

* `${driver_prefix}_DRIVER_MODULE`
* `${driver_prefix}_DRIVER_NAME`
* `${driver_prefix}_DRIVER_CLASS`
* `${driver_prefix}_XA_DATASOURCE_CLASS`

External datasource
-------------------

External datasources are datasources that are referencing drivers not present in the default configuration.
You configure them by using the same `PREFIX_*` env variable defined for _Internal datasources_.
In addition you use `PREFIX_DRIVER` env var to specify the driver name.

To specify external datasources, you can create one or more environment files. 
These will be read on startup of the server. To configure the environment files, you can do something like:

    `ENV_FILES=/etc/extensions/file1.env,/etc/extensions/file2.env`

Then assuming that the image contains the env files in these locations, 
it will use the prefixes in the `DATASOURCES` variable contained in the file to look for variables in the file with those prefixes. 
An example:

```
$cat /etc/extensions/file1.env
DATASOURCES=MYDB

# The "MYDB" database
#
MYDB_DATABASE=demo
MYDB_DRIVER=mydb-driver
MYDB_JNDI=java:jboss/datasources/MyDBDS
MYDB_USERNAME=demo
MYDB_PASSWORD=demo
MYDB_SERVICE_PORT=5432
MYDB_SERVICE_HOST=hostname
MYDB_JTA=true
MYDB_NONXA=true
MYDB_URL="jdbc:mydb://hostname:5432/demo"
```

Note: By locating your env file in `<application src>/configuration` directory it will be automatically copied to $JBOSS_HOME/standalone/configuration directory.