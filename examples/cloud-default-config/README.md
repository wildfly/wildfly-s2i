# PostgreSQL datasource example running with the default cloud config

In this example we are provisioning a WildFly server with a server configuration similar to the one in the centos7 WildFly images.
It contains a datasource and driver to access a PostgreSQL datasource.

The builder and runtime images are running JDK17.

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`
* `org.wildfly.cloud:wildfly-cloud-galleon-pack`
* `org.wildfly:wildfly-datasources-galleon-pack`

## Galleon layers

* `cloud-default-config`
* `postgresql-datasource`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* WildFly Helm charts `wildfly_v2/wildfly`

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) that must be set in the OpenShift deployment environment

* `JAVA_OPTS_APPEND=--add-exports=jdk.naming.dns/com.sun.jndi.dns=ALL-UNNAMED` Required when running on JDK17 with jgroups subsystem present in the server configuration.

# WildFly cloud feature-pack added features

* The server logs are redirected to the console. 
* Automatically compute and set `jboss.node.name` system property to a valid value. That is required by transactions `node-identifier attribute` attribute. 

# Pre-requisites

* You are logged into an OpenShift cluster and have `oc` command in your path

* You have installed Helm. Please refer to [Installing Helm page](https://helm.sh/docs/intro/install/) to install Helm in your environment

* You have installed WildFly Helm charts for WildFly s2i V2

 ```
helm repo add wildfly_v2 https://jmesnil.github.io/wildfly-charts/
```

# Example steps

1. Create and configure a PostgreSQL data base server:

```
oc new-app --name database-server \
     --env POSTGRESQL_USER=admin \
     --env POSTGRESQL_PASSWORD=admin \
     --env POSTGRESQL_DATABASE=sampledb \
     postgresql
```

2. Deploy the example application using WildFly Helm charts

```
helm install postgresql-app-default-config -f helm.yaml wildfly_v2/wildfly
```

5. Add a new task:

`curl -X POST https://$(oc get route postgresql-app-default-config --template='{{ .spec.host }}')/tasks/title/foo`

6. Get all the tasks:

`curl https://$(oc get route postgresql-app-default-config --template='{{ .spec.host }}')`

