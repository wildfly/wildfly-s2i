# Multiple PostgreSQL datasource example

In this example we are provisioning a WildFly server containing a driver and multiple datasources for PostgreSQL databases.

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`
* `org.wildfly.cloud:wildfly-cloud-galleon-pack`
* `org.wildfly:wildfly-datasources-galleon-pack`

## Galleon layers

* `cloud-server`
* `postgresql-driver`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* Helm chart for WildFly `wildfly/wildfly`. Minimal version `2.0.0`.

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml), that must be set in the OpenShift deployment environment

|Name|Description|
|----|-----------|
|`DB_SERVICE_PREFIX_MAPPING`|It is used to define the mapping prefixes for datasources. The allowed value for this variable is a comma-separated list of POOLNAME-DATABASETYPE=PREFIX triplets, where POOLNAME is used as the pool-name in the datasource, DATABASETYPE is the database driver to use, PREFIX is the prefix used in the names of environment variables that are used to configure the datasource.|
|`{POOLNAME}_{DATABASETYPE}_SERVICE_HOST`|Defines the database server’s host name or IP address to be used in the datasource’s connection-url property. Required if {PREFIX}_URL is not defined, this variable is required for internal datasources. External datasources don't use this environment variable.|
|`{POOLNAME}_{DATABASETYPE}_SERVICE_PORT`|Defines the database server’s port for the datasource. Required if {PREFIX}_URL is not defined, this variable is required for internal datasources. External datasources don't use this environment variable.|
|`{PREFIX}_DATABASE`|Defines the database name for the datasource. Required if {PREFIX}_URL is not defined, this variable is required for internal datasources. External datasources don't use this environment variable.|
|`{PREFIX}_DRIVER`|Defines Java database driver for the datasource. This environment variable must be defined only for external datasources. In case of an internal datasource, the datasource driver name in derived from the type of the datasource in use. For PostgreSQL datasource, the driver name is 'postgresql'. For MySQL, the name is 'mysql'. Optional, for internal datasources. Required for external datasources.|
|`{PREFIX}_JNDI`|Defines the JNDI name for the datasource. Defaults to java:jboss/datasources/POOLNAME_DATABASETYPE, where POOLNAME and DATABASETYPE are taken from the triplet described in DB_SERVICE_PREFIX_MAPPING. This setting is useful if you want to override the default generated JNDI name.|
|`{PREFIX}_MAX_POOL_SIZE`|Defines the maximum pool size option for the datasource. Optional.|
|`{PREFIX}_MIN_POOL_SIZE`|Defines the minimum pool size option for the datasource. Optional.|
|`{PREFIX}_PASSWORD`|Defines the password for the datasource. Required.|
|`{PREFIX}_USERNAME`|Defines the username for the datasource. Required.|
|`{PREFIX}_NONXA`|Defines the datasource as a non-XA datasource. Defaults to false.|

__Note:__ Please refer to the WildFly datasources module [documentation](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/launch/datasources/module.yaml) for information on how to use these environment variables and their default values.
# WildFly cloud feature-pack added features

* The server logs are redirected to the console. 
* Automatically compute and set `jboss.node.name` system property to a valid value. That is required by transactions `node-identifier attribute` attribute. 

# Pre-requisites

* You are logged into an OpenShift cluster and have `oc` command in your path

* You have installed Helm. Please refer to [Installing Helm page](https://helm.sh/docs/intro/install/) to install Helm in your environment

* You have installed the repository for the Helm charts for WildFly

 ```
helm repo add wildfly https://docs.wildfly.org/wildfly-charts/
```
----
**NOTE**

If you have already installed the Helm Charts for WildFly, make sure to update your repository to the latest version.

```
helm repo update
```
----

# Example steps

1. Create and configure the first PostgreSQL database server:

```
oc new-app --name database-server \
     --env POSTGRESQL_USER=admin \
     --env POSTGRESQL_PASSWORD=admin \
     --env POSTGRESQL_DATABASE=sampledb \
     postgresql:latest
```
2. Create and configure the second PostgreSQL database server:

```
oc new-app --name database-server-2 \
     --env POSTGRESQL_USER=admin \
     --env POSTGRESQL_PASSWORD=admin \
     --env POSTGRESQL_DATABASE=sampledb \
     postgresql:latest
```

3. Deploy the example application using WildFly Helm charts

```
helm install postgresql-multiple-ds-app -f helm.yaml wildfly/wildfly
```

4. Add a new task:

```
curl -X POST https://$(oc get route postgresql-multiple-ds-app --template='{{ .spec.host }}')/tasks/title/foo
```

5. Get all the tasks:

```
curl https://$(oc get route postgresql-multiple-ds-app --template='{{ .spec.host }}')
```

6. Add a new product:

```
curl -X POST https://$(oc get route postgresql-multiple-ds-app --template='{{ .spec.host }}')/products/name/bar
```

7. Get all the products:

```
curl https://$(oc get route postgresql-multiple-ds-app --template='{{ .spec.host }}')/products
```
