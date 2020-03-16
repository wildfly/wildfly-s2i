@wildfly/wildfly-builder
Feature: Check HTTPS configuration

  Scenario: Configure HTTPS
    When container is started with env
      | variable                           | value                       |
      | HTTPS_PASSWORD                 | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR             | /opt/wildfly                    |
      | HTTPS_KEYSTORE                 | keystore.jks                |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value /opt/wildfly/keystore.jks on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']/*[local-name()='ssl']/*[local-name()='keystore']/@path
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']/*[local-name()='ssl']/*[local-name()='keystore']/@keystore-password
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value ApplicationRealm on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@security-realm
  
  Scenario: Configure HTTPS, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
      | variable                           | value                       |
      | GALLEON_PROVISION_LAYERS           | cloud-server   |
      | HTTPS_PASSWORD                 | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR             | /opt/wildfly                    |
      | HTTPS_KEYSTORE                 | keystore.jks                |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value /opt/wildfly/keystore.jks on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']/*[local-name()='ssl']/*[local-name()='keystore']/@path
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']/*[local-name()='ssl']/*[local-name()='keystore']/@keystore-password
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value ApplicationRealm on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@security-realm

  Scenario: Use Elytron for HTTPS
    When container is started with env
      | variable                      | value                       |
      | HTTPS_PASSWORD                | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR            | /opt/wildfly                    |
      | HTTPS_KEYSTORE                | keystore.jks                |
      | HTTPS_KEYSTORE_TYPE           | JKS                         |
      | CONFIGURE_ELYTRON_SSL         | true                        |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value LocalhostSslContext on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@ssl-context
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='credential-reference']/@clear-text
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value JKS on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='implementation']/@type
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value /opt/wildfly/keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='file']/@path

  Scenario: Use Elytron for HTTPS
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
      | variable                      | value                       |
      | HTTPS_PASSWORD                | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR            | /opt/wildfly                    |
      | HTTPS_KEYSTORE                | keystore.jks                |
      | HTTPS_KEYSTORE_TYPE           | JKS                         |
      | CONFIGURE_ELYTRON_SSL         | true                        |
      | GALLEON_PROVISION_LAYERS      | cloud-server                |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value LocalhostSslContext on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@ssl-context
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='credential-reference']/@clear-text
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value JKS on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='implementation']/@type
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value /opt/wildfly/keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='file']/@path
