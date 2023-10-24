This project defines Images allowing you to build and deploy WildFly applications on the cloud.

Documentation for WildFly S2I (Source to Image) and runtime images can be found [there](https://docs.wildfly.org/wildfly-s2i/).

# Relationship with WildFly s2i centos7 images

These new images replace the `quay.io/wildfly/wildfly-centos7` and `quay.io/wildfy/wildfly-runtime-centos7` images.

As opposed to the `wildfly-centos7` WildFly s2i builder image that is containing a WildFly server, the new builder image 
is a generic builder allowing to build image for any WildFly releases.

Releasing new images is no more bound to WildFly server releases. Releases are done for fixes and new features done in the image.

# Building the images

You must have [cekit](https://github.com/cekit/cekit) installed.

## Building the JDK11 images

* `cd wildfly-builder-image; cekit build --overrides=jdk11-overrides.yaml docker`
* `cd wildfly-runtime-image; cekit build --overrides=jdk11-overrides.yaml docker`

## Building the JDK17 images

* `cd wildfly-builder-image; cekit build --overrides=jdk17-overrides.yaml docker`
* `cd wildfly-runtime-image; cekit build --overrides=jdk17-overrides.yaml docker`