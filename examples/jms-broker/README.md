# WildFly embedded broker used as a remote broker

In this example we are deploying 3 WildFly applications on OpenShift:

* A broker configured with a persistent storage to store not delivered messages.
* A jms message provider. A servlet that sends messages to a queue.
* A jms consumer. An MDB EJB that consumes messages.

WARNING: You can't scale the JMS Broker deployment beyond 1. To be able to scale the broker, clustering should be configured at the broker level. This is outside the scope of this example. 

The builder and runtime images are running JDK11.

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`
* `org.wildfly.cloud:wildfly-cloud-galleon-pack`

## Galleon layers

* `cloud-server`, for the producer and consumer applications.
* `core-server`, for the jms broker.
* `ejb`, for the mdb consumer.
* `embedded-activemq`, for the jms broker.

## CLI scripts
WildFly CLI scripts executed at packaging time

CLI scripts are run in order to fine tune the 3 servers:

* `broker`: To create HELLOWORLDMDBTopic and HELLOWORLDMDBQueue, disable security and configure journal path to reference persistent volumes.
* `producer`: To create external topic and queue, configure socket binding to the remote broker, pooled connection factory and http-connector.
* `mdb-consumer`: To create external topic and queue, configure socket binding to the remote broker, pooled connection factory and http-connector.

NB: In order to adapt the configuration to the execution context, the expression `${env.BROKER_HOST}` 
is set in the producer and mdb-consumer socket-binding `host` attribute value. The env variable is set in the WildFly Helm chart yaml file.

## Extra content
Extra content packaged inside the provisioned servers

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* Helm chart for WildFly `wildfly/wildfly`. Minimal version `2.1.0`.

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) that must be set in the OpenShift deployment environment

* None

# WildFly cloud feature-pack added features

* The remote connection factory is configured with `reconnect-attempts=-1`, allowing the clients to reconnect when the broker is down. 

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

1. Create the persistent volume.

```
oc create -f broker/jms-volume-claim.yaml
```

2. Deploy the broker using WildFly Helm charts

```
helm install jms-broker -f broker/helm.yaml wildfly/wildfly
```

3. Deploy the producer using WildFly Helm charts

```
helm install jms-producer -f producer/helm.yaml wildfly/wildfly
```

4. Deploy the consumer using WildFly Helm charts

```
helm install mdb-consumer -f mdb-consumer/helm.yaml wildfly/wildfly
```

Wait for the pods to be ready. It can takes some minutes for the images to be built and deployed.
You can check the status of the pods by calling: `oc get pods -w`.


5. Produces messages

`curl https://$(oc get route jms-producer --template='{{ .spec.host }}')/HelloWorldMDBServletClient`

Check the logs of the mdb-consumer, you will see the traces of the received messages.

# Broker failure scenario, messages are persisted

1. Scale down the mdb-consumer

`oc scale --replicas=0 deployments mdb-consumer`

2. Produces messages

`curl https://$(oc get route jms-producer --template='{{ .spec.host }}')/HelloWorldMDBServletClient`

These messages are persisted, waiting for a consumer to come online.

3. Scale down the broker, emulates a failure.

`oc scale --replicas=0 deployments jms-broker`

4. Scale up the broker

`oc scale --replicas=1 deployments jms-broker`

WARNING: You can't scale the JMS Broker deployment beyond 1. To be able to scale the broker, clustering should be configured at the broker level. This is outside the scope of this example. 

5. Scale up the mdb-consumer

`oc scale --replicas=1 deployments mdb-consumer`

Once the pod is ready, you will notice in the log that the messages are getting delivered.
