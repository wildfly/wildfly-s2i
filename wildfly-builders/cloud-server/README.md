
Project to generate an S2I builder image for a cloud-server WildFly server. This builder can then be used when building an application image.

The steps:

* Make sure to update to the latest Helm release (requires 2.3.0 as a minimum): `helm repo update`

* `helm install cloud-server-builder -f helm.yaml wildfly/wildfly`

==> The `cloud-server-builder` imagestream can then be used as an S2I builder image to build application image.
