# Enable transient logging, WildFly s2i example

It is a common practice to temporarily enable traces when debugging an application. In this example we are enabling the 
`org.wildfly.security` logger, redirect the traces to the CONSOLE and disable the file handler.

To do so we are relying on the capability offered by the WildFly S2I builder and runtime images to execute a WildFly CLI script at launch time.

In this example we are creating a config map from a WildFly CLI script and mount it as a volume in the OpenShift deployment.

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) that must be set in the OpenShift deployment environment

* `CLI_LAUNCH_SCRIPT`. To provide the path of the CLI script file to execute

# Pre-requisites

* You are logged into an OpenShift cluster and have `oc` command in your path

* You have built and deployed one of the examples. We are using the `elytron-oidc-client` example but the same applies to all examples

# Example steps

1. Creating a configmap

The file `logging.cli` located in the current directory is used to create the config map. It contains the CLI operations required to update the 
logging subsystem

`oc create configmap logging-cli --from-file=./logging.cli`

2. Mounting the script

We are mounting the CLI script that this configmap references in the `/tmp/cli-scripts` directory

`oc set volume deployment/elytron-oidc-client-app --add --type=configmap --configmap-name=logging-cli --mount-path=/tmp/cli-scripts`

3. Configuring the deployment environment

Add the `CLI_LAUNCH_SCRIPT` to the Environment of the `elytron-oidc-client-app` deployment

`oc set env deployment/elytron-oidc-client-app CLI_LAUNCH_SCRIPT=/tmp/cli-scripts/logging.cli`

Then do an upgrade of the Helm charts to reflect your changes done to the deployment

`helm upgrade elytron-oidc-client-app wildfly_v2/wildfly`

4. The deployment will restart, access the logs, you will notice that the `org.wildfly.security`debug traces are printed in the console
