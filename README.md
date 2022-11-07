This project defines Images allowing you to build and deploy WildFly applications on the cloud.

# Relationship with WildFly s2i centos7 images

These new images replace the `quay.io/wildfly/wildfly-centos7` and `quay.io/wildfy/wildfly-runtime-centos7` images.

As opposed to the `wildfly-centos7` WildFly s2i builder image that is containing a WildFly server, the new builder image 
is a generic builder allowing to build image for any WildFly releases.

Releasing new images is no more bound to WildFly server releases. Releases are done for fixes and new features done in the image.

# WildFly - UBI8 runtime image

An image containing all you need to run a WildFly Server. This image is to be used in a docker build to install a WildFly server.

* JDK11 based [runtime image](wildfly-runtime-image/image.yaml): `docker pull quay.io/wildfly/wildfly-runtime-jdk11:latest`

* JDK17 based [runtime image](wildfly-runtime-image/jdk17-overrides.yaml): `docker pull quay.io/wildfly/wildfly-runtime-jdk17:latest`

The example [docker-build](examples/docker-build) covers building an image from your Maven application project.

## Image API

When running a WildFly server inside the WildFly S2i runtime, you can use this [these environment variables](https://github.com/jboss-container-images/openjdk/blob/develop/modules/jvm/api/module.yaml) to configure the Java VM.
The WildFly S2i runtime image is exposing a set of [environment variables](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) to fine tune the server execution.

# WildFly - UBI8 S2I builder image

## S2I build workflow

This image contains all you need to execute a Maven build of your project during an S2I build phase (using [s2i tooling](https://github.com/openshift/source-to-image) or OpenShift).

The builder image expects that, during the Maven build, a WildFly server containing the deployment is being provisioned (by default in `<application project>/target/server` directory). This provisioned server 
is installed by the image in `/opt/server`. Making the generated application image runnable.

In order to provision a server during the build phase you must integrate (generally in a profile named `openshift` profile) an execution of the  [WildFly Maven plugin](https://github.com/wildfly/wildfly-maven-plugin/).

Documentation of the WildFly Maven plugin can be found [there](https://docs.wildfly.org/wildfly-maven-plugin/).

## S2I builder images

* JDK11 based [builder image](wildfly-builder-image/image.yaml): `docker pull quay.io/wildfly/wildfly-s2i-jdk11:latest`

* JDK17 based [builder image](wildfly-builder-image/jdk17-overrides.yaml): `docker pull quay.io/wildfly/wildfly-s2i-jdk17:latest`


## Using the S2I builder image

The more efficient way to use the WildFly S2I builder image to construct a WildFly application image is by using [WildFly Helm charts](https://github.com/wildfly/wildfly-charts).
WildFly Helm Charts  are automating the build (on OpenShift) and deployment of your application by the mean of a simple yaml file.

The [examples](examples) directory contains Maven projects and documentation allowing you to get started.

----
**NOTE**

If you are using the legacy centos7 S2I images for WildFly, you must stay on the `1.x` version of the Helm Chart for WildFly:

```
helm install my-legacy-app -f helm.yaml wildfly/wildfly --version ^1.x
```
----

## WildFly cloud Galleon feature-pack

The [WildFly cloud feature-pack](https://github.com/wildfly-extras/wildfly-cloud-galleon-pack) contains all the cloud specifics that were contained in the `wildfly/wildfly-centos7` image.
This feature-pack has to be provisioned along with the WildFly feature-pack. 

This [example](examples/web-clustering) contains a Maven project that makes use of some of the `org.wildfly.cloud:wildfly-cloud-galleon-pack` 
features to highlight web session sharing.

More Maven projects that make use of the WildFly cloud feature-pack can be found in the [test](test) directory.

For more information on the WildFly cloud feature-pack features, check [this documentation](https://github.com/wildfly-extras/wildfly-cloud-galleon-pack/blob/main/README.md).

## Backward compatible S2I workflow

In case you want to keep your existing project that used to work with the legacy WildFly S2i builder (`quay.io/wildfly/wildfly-centos7`) image, you can use a set of environment variables 
to initiate a server provisioning prior to execute the Maven build of your application:

* `GALLEON_PROVISION_FEATURE_PACKS`: Comma separated lists of Galleon feature-packs, for example: 
`GALLEON_PROVISION_FEATURE_PACKS=org.wildfly:wildfly-galleon-pack:26.1.0.Final,org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.1.Final` 

* `GALLEON_PROVISION_LAYERS`: Comma separated lists of Galleon layers, for example: `GALLEON_PROVISION_LAYERS=cloud-server`

NB: This support is deprecated. You are strongly advised to update your project to integrate the [WildFly Maven plugin](https://github.com/wildfly/wildfly-maven-plugin/) in your Maven project.


# OpenShift `oc` usage

* Adding the JDK 11 image streams: `oc create -f imagestreams/wildfly-s2i-jdk11.yaml` and `oc create -f imagestreams/wildfly-runtime-jdk11.yaml`.
`wildfly-s2i-jdk11` and `wildfly-runtime-jdk11` imagestreams are created.

* Adding the JDK 17 image streams: `oc create -f imagestreams/wildfly-s2i-jdk17.yaml` and `oc create -f imagestreams/wildfly-runtime-jdk17.yaml`.
`wildfly-s2i-jdk17` and `wildfly-runtime-jdk17` imagestreams are created.

Create a new application from the `wildfly-s2i-jdk11` imagestream (s2i build and OpenShift deployment) with a `jaxrs` provisioned server:

* `oc new-app --name=my-app wildfly-s2i-jdk11~https://github.com/wildfly/wildfly-s2i --context-dir=examples/jsf-ejb-jpa`

Create a route:

* `oc expose svc/my-app`

# Using image streams with Helm chart for WildFly

In order to use the imported WildFly s2i builder and runtime imagestreams, you can use imagestreams tag or id.

When setting the `kind` to the `ImageStreamTag` value, you must set the `builderImage` and `runtimeImage` to the `<imagestream name>:latest` value.
When setting the `kind` to the `ImageStreamImage` value, you must set the `builderImage` and `runtimeImage` to the `<imagestream name>@image_id` value.

For example, usage of JDK 17 builder and runtime imagestream tags:

```
  s2i:
    builderImage: wildfly-s2i-jdk17:latest
    runtimeImage: wildfly-runtime-jdk17:latest
    kind: ImageStreamTag
```

# Building the images

You must have [cekit](https://github.com/cekit/cekit) installed.

## Building the JDK11 images

* `cd wildfly-builder-image; cekit build docker`
* `cd wildfly-runtime-image; cekit build docker`

## Building the JDK17 images

* `cd wildfly-builder-image; cekit build --overrides=jdk17-overrides.yaml docker`
* `cd wildfly-runtime-image; cekit build --overrides=jdk17-overrides.yaml docker`