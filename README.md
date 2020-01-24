Wildfly - CentOS Docker images for Openshift
============================================

NOTE: The WildFly S2I image is now developed in this repository. It replaces the
repository [https://github.com/openshift-s2i/s2i-wildfly](https://github.com/openshift-s2i/s2i-wildfly) that can still be used to build older images.

This repository contains the source for building 2 different WildFly docker images:

* S2I WildFly builder image. Build a WildFly application as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).
The resulting image can be run using [Docker](http://docker.io).

* WildFly runtime image. An image that contains the minimal dependencies needed to run WildFly with deployed application.
This image is not runnable, it is to be used to chain a docker build with an image created by the WildFly S2I builder image.

NB: The image created by chaining an s2i build and a docker build is a good candidate to be managed by the [WildFly Operator](https://github.com/wildfly/wildfly-operator)

CentOS versions currently provided are:
* CentOS7


Building the images
-------------------

Images are built using [docker community edition](https://docs.docker.com/) and [cekit version 3](https://cekit.readthedocs.io/en/latest/index.html). You will also need the [docker-squash module](https://github.com/goldmann/docker-squash)
Mac OSX installation and build [tips](doc/build-mac.md).

Cloning the repository:

```
$ git clone https://github.com/wildfly/wildfly-s2i
$ cd wildfly-s2i
```

Building WildFly s2i builder image from scratch:

```
$ cd wildfly-builder-image
$ cekit build docker
```

Building WildFly runtime image from scratch:

```
$ cd wildfly-runtime-image
$ cekit build docker
```

Building WildFly s2i builder image with a locally built WildFly server

`build-s2i-image.sh` script steps:

* Builds WildFly (`clean install -DskipTests -Drelease`) if `--no-wildfly-build` is not set. If you have already build WildFly be sure to have used the `-Drelease` maven argument.
* Constructs and zip a local maven repository that contains all maven artifacts required by WildFly (JBoss module jars). NB during this phase an http server is started on port 7777 to serve maven local cache. 
* Creates the `wildfly/wildfly-centos7:dev-snapshot` s2i builder docker image using the zipped repository.

```
$ cd tools
$ ./build-s2i-image.sh <path to wildfly directory> [--no-wildfly-build]
```

Building your own application image

The script `tools/build-app-image.sh` uses s2i command line tool and docker to create an image from your application src.

* By default it uses `quay.io/wildfly/wildfly-centos7` and `quay.io/wildfly/wildfly-runtime-centos7` images. You can provide your own wildfly s2i builder and runtime images.

* If no application name is provided, the image name is derived from the application src directory.

* You can provide Galleon layers in order to build a trimmed-down server.

```
$ cd tools
$ ./build-app-image.sh <path to your app maven project> [--app-name=<application name>] [--galleon-layers=<comma separated list of layers>] [--wildfly-builder-image=<wildfly s2i builder image>] [--wildfly-runtime-image=<wildfly runtime image>]
```

S2I Usage
---------
To build a simple [jee application](https://github.com/openshift/openshift-jee-sample)
using standalone [S2I](https://github.com/openshift/source-to-image) and then run the
resulting image with [Docker](http://docker.io) execute:

```
$ s2i build git://github.com/openshift/openshift-jee-sample wildfly/wildfly-centos7:latest wildflytest
$ docker run -p 8080:8080 wildflytest
```

**Accessing the application:**
```
$ curl 127.0.0.1:8080
```

Chaining s2i build with runtime image
-------------------------------------
The following Dockerfile uses multi-stage build to chain builds to create a lightweight image.

NB: In order to be able to copy the server to the runtime image, the server must have been provisioned using galleon during s2i build.
This is done by using one of the Galleon env variables or by defining a `galleon/provisioning.xml` file at the root of the application src.

```
FROM quay.io/wildfly/wildfly-runtime-centos7:latest
COPY --from=wildflytest:latest /s2i-output/server $JBOSS_HOME
USER root
RUN chown -R jboss:root $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME
RUN ln -s $JBOSS_HOME /wildfly
USER jboss
CMD $JBOSS_HOME/bin/openshift-launch.sh
```

To build the docker image:
* Copy the Dockerfile content into a `Dockerfile` file
* Adjust the `--from` argument to reference the image you first built with s2i
* In the directory that contains the `Dockerfile` run: `docker build --squash -t wildflytest-rt .`

Test
---------------------
This repository also provides a [S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple WildFly application built on top of the wildfly image.
The tests also create a chained build to build a WildFly application runtime image from an s2i build.

```
$ make test
```
When running tests, the WildFly docker images are first built.

Repository organization
------------------------

* [doc/](doc) some documentation content referenced from this README file.

* [imagestreams/](imagestreams) contains image streams registered in [openshift library](https://github.com/openshift/library/blob/master/community.yaml)

* [make/](make) contains make scripts

* [templates](templates) templates you can add to a local openshift cluster (eg: `oc create -f templates/wildfly-s2i-chained-build-template.yml`)
  * `wildfly-builder-image-stream.yml` builder image stream
  * `wildfly-runtime-image-stream.yml` runtime image stream
  * `wildfly-s2i-chained-build-template.yml` template that build an application using s2i and copy the WildFly server and deployed app inside the WildFly runtime image.

* [test/](test) contains test applications and make test `run` script

* [wildfly-builder-image/](wildfly-builder-image) contains builder image yaml file

* [wildfly-modules/](wildfly-modules) contains cekit modules specific to wildfly. NB: These modules are progressively removed and added to the [wildfly-cekit-modules](http://github.com/wildfly/wildfly-cekit-modules) repository.

* [wildfly-runtime-image](wildfly-runtime-image) contains runtime image yaml file

Hot Deploy
------------------------

Hot deploy is enabled by default for all WildFly versions.
To deploy a new version of your web application without restarting, you will need to either rsync or scp your war/ear/rar/jar file to the /wildfly/standalone/deployments directory within your pod.

Image name structure
------------------------
##### Structure: openshift/3

1. Platform name (lowercase) - `wildfly`
2. Base builder image - `centos7`
3. WildFly version or `latest`

Example: `wildfly/wildfly-centos7:17.0`

Environment variables to be used at s2i build time
--------------------------------------------------

To set environment variables, you can place them as a key value pair into a `.s2i/environment`
file inside your source code repository.

* `GALLEON_PROVISION_SERVER` [DEPRECATED, Use of `GALLEON_PROVISION_LAYERS` is the way to provision custom server]

    The image contains a set of pre-defined galleon definitions that you can use to provision a custom WildFly server during s2i build.
    The set of built-in descriptions you can use as value of the env var are:
     * full-profile (Vanilla WildFly configuration for standalone and domain)
     * slim-default-server. The default server present in the builder image. JBoss module artifacts are retrieved from local maven repository.
     * fat-default-server. Same server configuration as the slim-default-server) but artifacts are retrieved from $JBOSS_HOME/modules.
     * standalone-profile (Vanilla WildFly configuration for standalone)

    Can't be used when `GALLEON_PROVISION_LAYERS` is used.

* `GALLEON_PROVISION_LAYERS`
    A comma separated list of layer names to compose a WildFly server. Any layer name 
    starting with `-` (eg:`-jpa`) will be excluded from the provisioning. Exclusion of layer can also be specified in 
    [galleon/provisioning.xml](test/test-app-jaxrs-exclude/galleon/provisioning.xml) file. Can't be used when `GALLEON_PROVISION_SERVER` is used.

    * Openshift Base layers:

      * `datasources-web-server`: Web + DB + core server (logging, management, elytron, ...). A servlet container (`web-server` layer), datasources support (`datasources` layer) and core subsystems (`core-server` layer). NB: security feature is offered thanks to elytron.

      * `jaxrs-server`: REST + JPA. Expands on `datasources-web-server` layer with the `jaxrs`, `cdi` and `jpa` layers, plus infinispan based *local* second level entity caching.

      * `cloud-server`: Expands on `jaxrs-server` with `resource-adapters`, `jms-activemq` (remote broker messaging, not embedded) and `observability` layers.

    * Openshift Decorator layers (to be used to complement base layers):

      * `keycloak`: Keycloak integration.

      * `observability`: MP Health, Metrics, Config, OpenTracing.


* `GALLEON_PROVISION_DEFAULT_FAT_SERVER`
    Set this env variable to true in order to provision the default server in a way that allows to copy it to the runtime image.

* `S2I_COPY_SERVER`
    When Galleon provisioning occurs, the server (and deployed apps) is copied to the directory `/s2i-output/server` directory. This can be disabled
    by setting this env variable to `false`.

* Maven env variables

    * The maven env variables you can set are documented in this [document](https://github.com/jboss-openshift/cct_module/tree/master/jboss/container/maven/api)

    * `MAVEN_OPTS`
      Contains JVM parameters to maven.  Will be appended to JVM arguments that are calculated by the image
      itself (e.g. heap size), so values provided here will take precedence.

    * `MAVEN_ARGS_APPEND`
      Contains command line parameters to maven. These will be appended to maven command line which executes the build.

Environment variables to be used when running application
---------------------------------------------------------

Java env variables

* The Java env variables you can set are documented in this [document](https://github.com/jboss-openshift/cct_module/tree/master/jboss/container/java/jvm/api)
* `ENABLE_JPDA`, set to true to enable debug on port 8787, disabled by default.
* `JAVA_OPTS_APPEND`, to append to options to `JAVA_OPTS`

WildFly server env variables

* Access Log [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/access-log-valve/module.yaml)

* Admin user [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/admin/module.yaml)

* Deployment scanner [env var](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/deployment-scanner/module.yaml)

* `CLI_GRACEFUL_SHUTDOWN` set to true to disable shutdown.

* `DEFAULT_DATASOURCE` defaut to `POSTGRESQL_DATASOURCE` or `MYSQL_DATASOURCE` or `EXAMPLE_DATASOURCE` or `ExampleDS`

* Elytron security [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/elytron/module.yaml)

* `EXAMPLE_DATASOURCE` default to `ExampleDS`

* Filters (Undertow) [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/filters/module.yaml)

* HTTPS config [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/https/module.yaml)

* JSON logging [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/json-logging/module.yaml)

* Keycloak [env var](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/keycloak/module.yaml)

* Logger categories [env vars](https://github.com/wildfly/wildfly-cekit-modules/tree/master/jboss/container/wildfly/launch/logger-category/module.yaml)

* Microprofiles config [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/mp-config/module.yaml)

* `MYSQL_DATABASE`

    If set, WildFly will attempt to define a MySQL datasource based on the assumption you have an OpenShift service named "mysql" defined.
    It will attempt to reference the following environment variables which are automatically defined if the "mysql" service exists:

    * `MYSQL_SERVICE_PORT`
    * `MYSQL_SERVICE_HOST`
    * `MYSQL_PASSWORD`
    * `MYSQL_USER`
    * `MYSQL_DATASOURCE`, default to MySQLDS, is used as the JNDI name of the datasource `java:jboss/datasources/$MYSQL_DATASOURCE`

* `OPENSHIFT_SMTP_HOST` default to `localhost`

* `POSTGRESQL_DATABASE`

    If set, WildFly will attempt to define a PostgreSQL datasource based on the assumption you have an OpenShift service named "postgresql" defined.
    It will attempt to reference the following environment variables which are automatically defined if the "postgresql" service exists:

    * `POSTGRESQL_SERVICE_PORT`
    * `POSTGRESQL_SERVICE_HOST`
    * `POSTGRESQL_PASSWORD`
    * `POSTGRESQL_USER`
    * `POSTGRESQL_DATASOURCE`, default to PostgreSQLDS, is used as the JNDI name of the datasource `java:jboss/datasources/$POSTGRESQL_DATASOURCE`

* Port offset [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/port-offset/module.yaml)

* Resource adapters [env vars](https://github.com/wildfly/wildfly-cekit-modules/blob/master/jboss/container/wildfly/launch/resource-adapters/module.yaml)

* `SCRIPT_DEBUG` set to true to enable launch script debug.

* `SERVER_CONFIGURATION` name of standalone XML configuration file. Default to `standalone.xml`

* `WILDFLY_ENABLE_STATISTICS` default to `true`

* `WILDFLY_MANAGEMENT_BIND_ADDRESS`  default to `0.0.0.0`

* `WILDFLY_PUBLIC_BIND_ADDRESS` default to the value returned by `hostname -i`

* `WILDFLY_TRACING_ENABLED` in default server configuration microprofile opentracing is not enabled. Set this env variable to `true` to enable it. In case your configuration contains
   opentracing (eg: cloud-profile), you can disable it by setting this env variable to `false`.

* Adding new datasources can be done by using env variables defined in this [document](doc/datasources.md)


Jolokia env variables

* The Jolokia env variables you can set are documented in this [document](https://github.com/jboss-openshift/cct_module/tree/master/jboss/container/jolokia/api)


Provisioning a custom server using [Galleon](https://docs.wildfly.org/galleon/)
-------------------------------------------------------------------------------

That is done during s2i build using the `GALLEON_PROVISION_LAYERS` env variable.

If you want to define your own WildFly server, create a directory named `galleon` at the root of your application sources project. This directory must
contains a provisioning.xml file. During s2i build, this file is used to provision a server.
This server is used to replace the one present in the s2i builder image (located in $JBOSS_HOME).

The Galleon feature-pack location to use is `wildfly-s2i@maven(org.jboss.universe:s2i-universe):current`, it is only available from the WildFly s2i builder image
(located in .m2/repository).

This feature-pack contains the default standalone.xml configuration required for OpenShift. In addition it exposes the following Galleon layers that you can combine with
the Openshift base layers or [WildFly defined galleon layers](https://docs.wildfly.org/16/Admin_Guide.html#defined-galleon-layers):
* mysql-datasource
* mysql-default-datasource
* mysql-driver
* postgresql-datasource
* postgresql-default-datasource
* postgresql-driver

Note: These Galleon layers are defined and documented in [wildfly-extras Galleon feature-pack](https://github.com/wildfly-extras/wildfly-datasources-galleon-pack).

As an example, this [custom configuration Galleon definition](wildfly-modules/jboss/container/wildfly/galleon/artifacts/opt/jboss/container/wildfly/galleon/definitions/cloud-profile-postgresql/config.xml)
defined in this [maven project](wildfly-modules/jboss/container/wildfly/galleon/artifacts/opt/jboss/container/wildfly/galleon/definitions/cloud-profile-postgresql)
combines the WildFly `cloud-profile` with the `postgresql-datasource`


S2i build time WildFly server customization hooks
-------------------------------------------------

 * Wildfly configuration files from the `<application source>/<cfg|configuration>` are copied into the wildfly configuration directory.

 * Pre-built war files from the `<application source>/deployments` are moved into the wildfly deployment directory.

 * Wildfly modules from the `<application source>/modules` are copied into the wildfly modules directory.

 * Execute WildFly CLI scripts by using `S2I_IMAGE_SOURCE_MOUNTS` and `install.sh` scripts as documented in [s2i core documentation](https://github.com/jboss-openshift/cct_module/tree/master/jboss/container/s2i/core/api)

 * Datasource drivers deployment thanks to S2I hooks. This [document](doc/datasources.md) covers the drivers deployment and configuration.

This [test application](test/test-app-custom) highlight the usage of these customization hooks (in combination of galleon provisioning a cloud-profile server).


OpenShift `oc` usage
--------------------

In case your openshift installation doesn't contain the images and templates:

* Adding the image streams: `oc create -f imagestreams/wildfly-centos7.yml` and `oc create -f imagestreams/wildfly-runtime-centos7.yml`.
`wildfly` and `wildfly-runtime` imagestreams are created.

* Adding the template: `oc create -f templates/wildfly-s2i-chained-build-template.yml`. Template `wildfly-s2i-chained-build-template` is created.

* The imagestreams and templates are added to the namespace (project) currently selected. It is recommended to add the imagestreams to the `openshift`
 namespace. In case you don't have access to the openshift namespace, you can still add the imagestreams to your project.
You will need to use `IMAGE_STREAM_NAMESPACE=<my project>` parameter when using the `wildfly-s2i-chained-build-template` template to create an application.

* When adding the `wildfly` imagestream to the `openshift` namespace, the OpenShift catalog is automatically populated with a the template `WildFly` allowing you to
create new build and new deployment from the OpenShift Web Console.

Building a new application image from the `wildfly-s2i-chained-build-template` (to be then managed by WildFly Operator):

* `oc new-app wildfly-s2i-chained-build-template`

Building a new application image from the `wildfly-s2i-chained-build-template` and provision a `cloud-profile` WildFly server (to be then managed by WildFly Operator):

* `oc new-app wildfly-s2i-chained-build-template -p GALLEON_PROVISION_SERVER=cloud-profile`

Building a new application image from the `wildfly-s2i-chained-build-template` with `wildfly` and `wildfly-runtime` imagestreams registered in `myproject` (to be then managed by WildFly Operator):

* `oc new-app wildfly-s2i-chained-build-template -p IMAGE_STREAM_NAMESPACE=myproject`

Starting a new deployment from an image created using `wildfly-s2i-chained-build-template` template (NB: it is advised to use the WildFly Operator instead):

* `oc new-app <namespace>/<image name> -n <namespace>`

Create a new application from the `wildfly` imagestream (s2i build and OpenShift deployment) with a `jaxrs` provisioned server:

* `oc new-app --name=my-app wildfly~https://github.com/openshiftdemos/os-sample-java-web.git --build-env GALLEON_PROVISION_SERVER=jaxrs`

Jolokia known issues
--------------------

* On some minishift versions (at least on v1/33.0) you need to disable security to allow Java console to connect to WildFly server Jolokia agent set `AB_JOLOKIA_AUTH_OPENSHIFT` and `AB_JOLOKIA_PASSWORD_RANDOM` to `false`

S2I build known issues
----------------------

**If UTF-8 characters are not displayed (or displayed as ```?```)**

This can be solved by providing to the JVM the file encoding. Set variable ```MAVEN_OPTS=-Dfile.encoding=UTF-8``` into the build variables

Copyright
--------------------

Released under the Apache License 2.0. See the [LICENSE](LICENSE) file.
