Datasources configuration
=========================

There are two types of datasources, internal and external.

Internal datasource
-------------------

Internal datasources uses one of the drivers that have been provisioned along with the WildFly server. 

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

* `PREFIX_DRIVER`

Defines Java database driver for the datasource.
Example value: postgresql

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


External datasource
-------------------

To specify external datasources, you need to create one or more environment files. 
These will be read on startup of the image. To configure the environment files, you can do something like:

    `ENV_FILES=/etc/extensions/file1.env,/etc/extensions/file2.env`

Then assuming that the image contains the env files in these locations, 
it will use the prefixes in the `DATASOURCES` variable contained in the file to look for variables in the file with those prefixes. 
An example:

```
$cat /etc/extensions/file1.env
DATASOURCES=TESTB
TESTB_SERVICE_HOST=localhost
TESTB_BACKGROUND_VALIDATION=true
-- SNIP --
```
