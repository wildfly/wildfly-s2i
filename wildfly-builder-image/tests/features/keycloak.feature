#IGNORE_TEST_RUN
#Keycloak tests can't be run starting WF27, missing some JBoss modules.
@ignore
@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Keycloak legacy tests

  Scenario: Provision the default config with keycloak deployments.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.2 |
     Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-keycloak-legacy using main
       | variable                   | value                                            |
       | ARTIFACT_DIR               | app-profile-jee-saml/target |
       | GALLEON_PROVISION_FEATURE_PACKS|org.wildfly:wildfly-galleon-pack:26.1.1.Final,org.wildfly.cloud:wildfly-cloud-galleon-pack:1.1.2.Final |
       | GALLEON_PROVISION_LAYERS|cloud-default-config|

  Scenario: deploys the keycloak example, add subsystem by script (future adapter). The app project is expected to install the keycloak adapters inside the server.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.2 |
      When container integ- is started with command bash
       | variable                 | value  |
       | SSO_REALM         | demo    |
       | SSO_URL           | http://localhost:8080/auth    |
    Then copy features/image/scripts/keycloak.cli to /tmp in container
    And run /opt/server/bin/jboss-cli.sh --file=/tmp/keycloak.cli in container once
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then file /tmp/boot.log   should contain Existing other application-security-domain is extended with support for keycloak
    Then file /tmp/boot.log   should contain WFLYSRV0025
    Then file /tmp/boot.log   should contain WFLYSRV0010: Deployed "app-profile-jee-saml.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee-saml.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee-saml on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/@entityID
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value EXTERNAL on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/@sslPolicy
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/*[local-name()='Keys']/*[local-name()='Key']/@signing 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value idp on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/*[local-name()='IDP']/@entityID 

  Scenario: deploys the keycloak example, add subsystem by script (future adapter) with ENV_FILES
    Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.2 |
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/keycloak.env |
    Then copy features/image/scripts/keycloak.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain Existing other application-security-domain is extended with support for keycloak
    And file /tmp/boot.log should contain WFLYSRV0025
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee-saml.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value app-profile-jee-saml on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/@entityID
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value EXTERNAL on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/@sslPolicy
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/*[local-name()='Keys']/*[local-name()='Key']/@signing 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value idp on XPath //*[local-name()='secure-deployment'][@name="app-profile-jee-saml.war"]/*[local-name()='SP']/*[local-name()='IDP']/@entityID 