@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Keycloak legacy tests

   Scenario: deploys the keycloak example, provision the default config. The app project is expected to install the keycloak adapters inside the server.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.2 |
     Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-keycloak-legacy using main
       | variable                   | value                                            |
       | ARTIFACT_DIR               | app-profile-jee/target,app-profile-jee-saml/target |
       | SSO_USE_LEGACY  | true |
       | SSO_REALM         | demo    |
       | SSO_URL           | http://localhost:8080/auth    |
       | GALLEON_PROVISION_FEATURE_PACKS|org.wildfly:wildfly-galleon-pack:26.1.0.Beta1,org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
       | GALLEON_PROVISION_LAYERS|cloud-default-config|
    Then container log should contain Existing other application-security-domain is extended with support for keycloak
    Then container log should contain WFLYSRV0025
    Then container log should contain WFLYSRV0010: Deployed "app-profile-jee.war"
    Then container log should contain WFLYSRV0010: Deployed "app-profile-jee-saml.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value demo on XPath //*[local-name()='realm']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee.war"]/*[local-name()='enable-cors']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value http://localhost:8080/auth on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee.war"]/*[local-name()='auth-server-url']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee-saml.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee-saml on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/@entityID
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value EXTERNAL on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/@sslPolicy
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/*[local-name()='Keys']/*[local-name()='Key']/@signing 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value idp on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/*[local-name()='IDP']/@entityID 