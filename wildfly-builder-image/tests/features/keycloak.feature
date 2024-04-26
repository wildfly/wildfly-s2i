@wildfly/wildfly-s2i
Feature: Keycloak saml tests

  Scenario: Provision the server with keycloak deployment.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.4 |
     Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-keycloak-saml using main
       | variable                   | value                 |

   Scenario: Enable keycloak automatic registration.
     Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.4 |
      When container integ- is started with env
       | variable          | value                         |
       | SSO_REALM         | demo                          |
       | SSO_URL           | http://localhost:8080/auth    |
     Then container log should contain WFLYSRV0010: Deployed "saml-app.war"
     Then container log should contain Existing other application-security-domain is extended with support for keycloak
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value saml-app.war on XPath //*[local-name()='secure-deployment']/@name
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value saml-app on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/@entityID
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value EXTERNAL on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/@sslPolicy
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/*[local-name()='Keys']/*[local-name()='Key']/@signing 
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value idp on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/*[local-name()='IDP']/@entityID 

  Scenario: deploys the keycloak example with ENV_FILES
    Given XML namespaces
       | prefix | url                          |
       | ns     | urn:jboss:domain:keycloak:1.4 |
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/keycloak.env |
    Then copy features/image/scripts/keycloak.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain Existing other application-security-domain is extended with support for keycloak
    And file /tmp/boot.log should contain WFLYSRV0010: Deployed "saml-app.war"
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value saml-app.war on XPath //*[local-name()='secure-deployment']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value saml-app on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/@entityID
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value EXTERNAL on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/@sslPolicy
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/*[local-name()='Keys']/*[local-name()='Key']/@signing 
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value idp on XPath //*[local-name()='secure-deployment'][@name="saml-app.war"]/*[local-name()='SP']/*[local-name()='IDP']/@entityID 