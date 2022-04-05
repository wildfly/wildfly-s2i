@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: OIDC tests

   Scenario: Check oidc subsystem configuration.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:wildfly:elytron-oidc-client:1.0 |
     Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-elytron-oidc-client with env and True using main
       | variable               | value                                            |
       | OIDC_PROVIDER_NAME | keycloak |
       | OIDC_PROVIDER_URL           | http://localhost:8080/auth/realms/demo    |
       | OIDC_SECURE_DEPLOYMENT_ENABLE_CORS        | true                          |
       | OIDC_SECURE_DEPLOYMENT_BEARER_ONLY        | true                          |
       ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0010: Deployed "oidc-webapp.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value keycloak on XPath //ns:provider/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value oidc-webapp.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='provider']/*[local-name()='enable-cors']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp.war"]/*[local-name()='bearer-only']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp.war"]/*[local-name()='enable-basic-auth'] 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value http://localhost:8080/auth/realms/demo on XPath //*[local-name()='provider']/*[local-name()='provider-url']

  Scenario: Check oidc subsystem configuration, legacy.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:wildfly:elytron-oidc-client:1.0 |
     Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-elytron-oidc-client-legacy with env and True using main
       | variable               | value                                            |
       | OIDC_PROVIDER_NAME | keycloak |
       | OIDC_PROVIDER_URL           | http://localhost:8080/auth/realms/demo    |
       | OIDC_SECURE_DEPLOYMENT_ENABLE_CORS        | true                          |
       | OIDC_SECURE_DEPLOYMENT_BEARER_ONLY        | true                          |
       | GALLEON_PROVISION_LAYERS | cloud-server,elytron-oidc-client |
       | GALLEON_PROVISION_FEATURE_PACKS|org.wildfly:wildfly-galleon-pack:26.1.0.Beta1,org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
    Then container log should contain WFLYSRV0010: Deployed "oidc-webapp-legacy.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value keycloak on XPath //ns:provider/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value oidc-webapp-legacy.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='provider']/*[local-name()='enable-cors']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp-legacy.war"]/*[local-name()='bearer-only']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="oidc-webapp-legacy.war"]/*[local-name()='enable-basic-auth'] 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value http://localhost:8080/auth/realms/demo on XPath //*[local-name()='provider']/*[local-name()='provider-url']