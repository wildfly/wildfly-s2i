# Building a WildFly server docker image

In this example we are making use of the WildFly runtime image to build a WildFly server docker image for our application (simple JAX_RS endpoint).
In order to create a WildFly server containing our application, we are using the [WildFly Maven Plugin](https://github.com/wildfly/wildfly-maven-plugin/).

The image is deployed and run locally using docker and to an Openshift cluster using Helm charts for WildFly.

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `wildfly@maven(org.jboss.universe:community-universe)`: Resolve the latest released WildFly server.

## Galleon layers

* `cloud-server`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* docker
* Helm chart for WildFly `wildfly/wildfly`. Minimal version `2.0.0`.

# Pre-requisites

* You have docker setup.

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

## Build the image

1. Build the application  and server

```
mvn clean package
```

2. Build the docker image

```
docker build -t myapp:latest .
```

## Run the image locally

1. Run the image

```
docker run myapp:latest
```

2. Access the endpoint

```
curl http://<docker image IP>:8080/
```

3. Stop the server

In the console type `Ctrl-C`.

## Deploy the image on Openshift

1. Push the image to the Openshift Sandbox

Make sure to set the `OPENSHIFT_IMAGE_REGISTRY` env variable with the actual route to the registry. 
When logging to the registry, the route to the registry will be printed on the console.

```
export IMAGE=myapp:latest
export OPENSHIFT_NS=$(oc project -q)
oc registry login
# Copy the route in the env variable OPENSHIFT_IMAGE_REGISTRY
OPENSHIFT_IMAGE_REGISTRY=$(oc registry info)
docker login -u openshift -p $(oc whoami -t)  $OPENSHIFT_IMAGE_REGISTRY
docker tag  $IMAGE $OPENSHIFT_IMAGE_REGISTRY/$OPENSHIFT_NS/$IMAGE
docker push  $OPENSHIFT_IMAGE_REGISTRY/$OPENSHIFT_NS/$IMAGE
```

2. Enable the pushed image stream resolution

```
oc set image-lookup myapp
```

3. Deploy the example application using WildFly Helm charts

```
helm install myapp -f helm.yaml wildfly/wildfly
```

4. Access the endpoint

```
curl https://$(oc get route myapp --template='{{ .spec.host }}')/
```
