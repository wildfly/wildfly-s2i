It is backward compatible.

WARNING: The application route must be SSL.


First deploy jboss SSO with admin/admin

- add WildFly realm

- create User demo, passord demo

- Add all permissions to the user in role mappping (needed to access the signing certificate).

- add user role

- make admin to be user role

ARTIFACT_DIR: app-profile-saml-jee-jsp/target

Deployment:

Env

SSO_URL=https://keycloak-server-myproject.192.168.42.38.nip.io/auth

SSO_REALM=WildFly

SSO_USERNAME=demo

SSO_PASSWORD=demo

HOSTNAME_HTTPS=sso-test-myproject.192.168.42.38.nip.io

SSO_SAML_CERTIFICATE_NAME=app-profile-saml

SSO_SAML_KEYSTORE=keystore.jks

SSO_SAML_KEYSTORE_PASSWORD=password

SSO_SAML_KEYSTORE_DIR=/etc/sso-saml-secret-volume

SSO_SAML_LOGOUT_PAGE=/index.jsp

SSO_SECRET=foo

Deploy apps first, the client will be created in keycloak

Go to admin console, click the saml client, SAML Keys, export

Use password for both passwords. Keep JKS and Key alias : app-profile-jee-saml

Download the keystore.

Create a secret: oc create secret saml-keystore-secret ~/Downloads/keystore.jks

Mount the secret as a volume: oc set volume domain/<the app> --add --name=sso-saml-keystore-volume --type=secret --secret-name=saml-keystore-secret --mount-path=/etc/sso-saml-secret-volume
When mounting the volume, the application will be re-deployed taking into account the new mounted volume.