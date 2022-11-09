# Usage of intermediate S2I builder to speed-up application build.

Generate an S2I builder image for `cloud-server` WildFly server. This builder is then reused to build the application image. The same builder 
can be used to build any application image that need the features provisioned by the `cloud-server` Galleon layer.

The steps:

* Make sure to update to the latest Helm release (requires 2.3.0 as a minimum): `helm repo update`

* Create the builder: `helm install cloud-server-builder -f https://raw.githubusercontent.com/wildfly/wildfly-s2i/main/wildfly-builders/cloud-server/helm.yaml wildfly/wildfly`

* Use the previously created builder to build the application image: `helm install app -f helm.yaml wildfly/wildfly`

==> You can then access the route of app.
