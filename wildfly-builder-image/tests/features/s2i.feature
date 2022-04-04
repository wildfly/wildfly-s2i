@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Wildfly s2i tests

  Scenario: Build the image with a server
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025

  Scenario: Test incremental build, no download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025
    And s2i build log should not contain Downloaded

  Scenario: Test extension called at startup.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-extension with env and true using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test extension called at build time, copy a file inside JBOSS_HOME.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-extension2 with env and true using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025
    Then file /opt/server/modules/org/foo/bar/test.txt should contain hello

  Scenario: Test custom settings with galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-settings with env and true using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then s2i build log should contain /home/jboss/.m2/settings.xml
    Then file /home/jboss/.m2/settings.xml should contain foo-repository
    Then container log should contain WFLYSRV0025

  Scenario: Test custom settings by env with galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and true using main
     | variable                     | value                                                 |
     | MAVEN_SETTINGS_XML           | /home/jboss/../jboss/../jboss/.m2/settings.xml |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then s2i build log should contain /home/jboss/../jboss/../jboss/.m2/settings.xml
    Then container log should contain WFLYSRV0025

  Scenario: Test execution of user CLI operations at S2I phase
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/vanilla-wildfly/test-app-s2i-cli-scripts with env and true using main
     | variable                               | value                                                 |
     | MY_ENVIRONMENT_CONFIGURATION           | my_env_configuration |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value prop-s2i-two-value on XPath //*[local-name()='system-properties']/*[local-name()='property'][@name='prop-s2i-two']/@value
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value prop-s2i-one-value on XPath //*[local-name()='system-properties']/*[local-name()='property'][@name='prop-s2i-one']/@value
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value my_env_configuration on XPath //*[local-name()='system-properties']/*[local-name()='property'][@name='prop-my-env']/@value
    Then container log should contain WFLYSRV0025
    Then container log should not contain WFLYCTL0056

  Scenario: Test jaxrs-server -jpa +jpa-distributed
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jpa2lc with env and True using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025
    Then check that page is served
      | property              | value                                   |
      | path                  | /                        |
      | port                  | 8080                                    |
    Then check that page is served
      | property              | value                                   |
      | path                  | /create/1               |
      | port                  | 8080                                    |
      | expected_phrase       | 1 created                               |
    Then check that page is served
      | property              | value                                   |
      | path                  | /isInCache/1            |
      | port                  | 8080                                    |
      | expected_phrase       | true                                    |
    Then check that page is served
      | property              | value                                   |
      | path                  | /cache/1                |
      | port                  | 8080                                    |
      | expected_phrase       | 1                                       |
    Then check that page is served
      | property              | value                                   |
      | path                  | /evict/1                |
      | port                  | 8080                                    |
      | expected_phrase       | 1 evict                                 |
    Then check that page is served
      | property              | value                                   |
      | path                  | /isInCache/1            |
      | port                  | 8080                                    |
      | expected_phrase       | false                                   |
    Then XML file /opt/server/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/server/.galleon/provisioning.xml should contain value jpa-distributed on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/server/.galleon/provisioning.xml should contain value jpa on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test jaxrs-server +ejb-lite, -ejb-local-cache +ejb-dist-cache. Verify JGroups configuration added by ejb-dist-cache
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-ejb with env and True using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025
    Then check that page is served
      | property              | value                                   |
      | path                  | /                           |
      | port                  | 8080                                    |
    Then check that page is served
      | property              | value                                   |
      | path                  | /messages/hello            |
      | port                  | 8080                                    |
      | expected_phrase       | sfsb_hello                              |
    Then XML file /opt/server/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/server/.galleon/provisioning.xml should contain value ejb-dist-cache on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/server/.galleon/provisioning.xml should contain value ejb-local-cache on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:jgroups:')]//*[local-name()='channel'][@name='ee' and @stack='tcp']
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:jgroups:')]//*[local-name()='transport'][@type='TCP' and @socket-binding='jgroups-tcp']
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:jgroups:')]//*[local-name()='transport'][@type='UDP' and @socket-binding='jgroups-udp']
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:jgroups:')]//*[local-name()='stack'][@name='tcp']/*[local-name()='protocol' and @type='MPING']
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:jgroups:')]//*[local-name()='stack'][@name='udp']/*[local-name()='protocol' and @type='PING']

  Scenario: Test building and running slim application
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-slim with env and true using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025
@wip
  Scenario: Test failing packaging.
    Given failing s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-invalid using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
