# Elytron OpenID Connect (OIDC) client example

In this example we are provisioning a WildFly server and deploying an application secured 
with OIDC (OpenID Connect).

In this example, the OIDC configuration is located inside the `WEB-INF/oidc.json` application file. The configuration expects the system property 
`org.wildfly.s2i.example.oidc.provider-url` to be set. 

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `org.wildfly:wildfly-galleon-pack`

## Galleon layers discovered by WildFly Glow

* `ee-core-profile-server`
* `elytron-oidc-client`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Openshift build and deployment
Technologies required to build and deploy this example

* Helm chart for WildFly `wildfly/wildfly`. Minimal version `2.0.0`.

# WildFly image API
Environment variables from the [WildFly image API](https://github.com/wildfly/wildfly-cekit-modules/blob/main/jboss/container/wildfly/run/api/module.yaml) that must be set in the OpenShift deployment environment

* None

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
----
**NOTE**

Be sure you have created OpenShift project. In some clusters it is created by default, whereas in others you have to create it manually.

Check what project is currently active:

```
oc project -q
```

If above command returns with error stating no project has been set, create a project using following command:

```
oc new-project myproject
```
----

# Example steps

1. Deploy an SSO server. Use the Sandbox Developer Catalog, search for sso and instantiate RH SSO 7.5 template. You can keep the default values 
when instantiating the template.

To retrieve the SSO admin user name and password that will be needed to log into the SSO admin console, 
access the SSO deployment config and look for `SSO_ADMIN_USERNAME` and `SSO_ADMIN_PASSWORD` env variable values.

2. Deploy the application with the Helm Chart for WildFly using the `helm.yaml` file to configure the application:

```
helm install elytron-oidc-client-app -f helm.yaml wildfly/wildfly
```

You can now query the route of the application (refered later with 
`<elytron-oidc-client-app route>`) with:

```
echo $(oc get route elytron-oidc-client-app --template='{{ .spec.host }}')
```

3. Create the SSO realm, user, role and client

  * Log into the SSO admin console (`https://<SSO route>/auth/`). You must use the values of `SSO_ADMIN_USERNAME` and `SSO_ADMIN_PASSWORD` to log-in. 
  * Create a Realm named `WildFly`
  * Create a Role named `Users`
  * Create a User named `demo`, password `demo`
  * Assign the role `Users` to the user `demo`
  * Create a Client named `simple-webapp` with a `openid-connect` Client Protocol and the Root URL set to  `https://<elytron-oidc-client-app route>`

4. Finally update the `helm.yaml` file to add the `OIDC_PROVIDER_URL` environment variable:

```yaml
build:
  ...
deploy:
  env:
    - name: OIDC_PROVIDER_URL
      value: <SSO WildFly Realm>
```

Replace `<SSO WildFly Realm>` with the URL you can get from:

```
echo https://$(oc get route sso --template='{{ .spec.host }}')/auth/realms/WildFly
```

When WildFly is started, this `OIDC_PROVIDER_URL` environment variable is used to set the `provider-url` field in the `oidc.json` deployment's file.

5. Upgrade the application with Helm:

```
helm upgrade elytron-oidc-client-app -f helm.yaml wildfly/wildfly
```

5. Access the application: `https://<elytron-oidc-client-app route>/`

6. Access the secured servlet from this page

7. Log-in using the `demo` user, `demo` password (that you created in the initial steps)

8. You should see a page containing the Principal ID

