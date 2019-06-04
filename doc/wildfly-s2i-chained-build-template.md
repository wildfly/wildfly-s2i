
WildFly chained build template
==============================

This is a template to build a lightweight image to be managed by the [WildFly Operator](https://github.com/wildfly/wildfly-operator)

This template creates 2 builds:

 - An S2I build named `<app-name>-build-artifacts` to build and deploy your application in WildFly.
 - A docker chained build named `<app-name>` to output the `<app-name>` docker image ready to be deployed in OpenShift.

Parameters
==========

* GIT parameters.

* Builtin Galleon Description Name

Builtin Galleon defined WildFly server that will be provisioned
during S2I build. For more information on using Galleon during S2I build check the [wildfly-s2i documentation](https://github.com/wildfly/wildfly-s2i/blob/master/README.md)

* ImageStreams Namespace

The namespace in which WildFly Imagestreams are registered. `openshift` is the default namespace.
