# Elytron OpenID Connect (OIDC) client example

In this example we are provisioning a WildFly server and deploying an application secured 
with OIDC (OpenID Connect).

In this example, the OIDC configuration is located inside the `WEB-INF/oidc.json` application file. The configuration expects the system property 
`org.wildfly.s2i.example.oidc.provider-url` to be set. 

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`

## Galleon layers

* `cloud-server`
* `elytron-oidc-client`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* Helm chart for WildFly `wildfly/wildfly`

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) that must be set in the OpenShift deployment environment

* `SERVER_ARGS`. Used to convey the system property that references the Keycloak server URL.

# Pre-requisites

* You are logged into an OpenShift cluster and have `oc` command in your path

* You have installed Helm. Please refer to [Installing Helm page](https://helm.sh/docs/intro/install/) to install Helm in your environment

* You have installed the repository for the Helm charts for WildFly

 ```
helm repo add wildfly https://docs.wildfly.org/wildfly-charts/
```

# Example steps

1. Deploy an SSO server. Use the Sandbox Developer Catalog, search for sso and instantiate RH SSO 7.5 template. You can keep the default values 
when instantiating the template.

To retrieve the SSO admin user name and password that will be needed to log into the SSO admin console, 
access the SSO deployment config and look for `SSO_ADMIN_USERNAME` and `SSO_ADMIN_PASSWORD` env variable values.

2. Deploy the example application using WildFly Helm charts

```
helm install elytron-oidc-client-app -f helm.yaml wildfly/wildfly
```

3. Create the SSO realm, user, role and client

  * Log into the SSO admin console (`https://<SSO route>/auth/`). You must use the values of `SSO_ADMIN_USERNAME` and `SSO_ADMIN_PASSWORD` to log-in. 
  * Create a Realm named `WildFly`
  * Create a Role named `Users`
  * Create a User named `demo`, password `demo`
  * Assign the role `Users` to the user `demo`
  * Create a Client named `simple-webapp` with a Valid Redirect uri of URL: `http://<elytron-oidc-client-app route>/simple-webapp/*`

4. Finally add the env variable to the `elytron-oidc-client-app` deployment to convey the system property to the server

`oc set env deployment/elytron-oidc-client-app SERVER_ARGS=-Dorg.wildfly.s2i.example.oidc.provider-url=https://<SSO route>/auth/realms/WildFly`

5. Access the application: `https://<elytron-oidc-client-app route>/simple-webapp`

6. Access the secured servlet.

7. Log-in using the `demo` user, `demo` password (that you created in the initial steps)

8. You should see a page containing the Principal ID

