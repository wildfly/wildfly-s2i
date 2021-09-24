@wip
@wildfly/wildfly-centos7
Feature: Wildfly Legacy extensions tests

  Scenario: Test preconfigure.sh
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_PRE_ADD_PROPERTY      | foo           |
      | GALLEON_PROVISION_LAYERS | cloud-server |
       | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-cloud-legacy-galleon-pack:25.0.0.Beta1 |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

Scenario: Test external driver created during s2i.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-custom with env and true using master
      | variable                     | value                                                       |
      | ENV_FILES                    | /opt/server/standalone/configuration/datasources.env |
      | GALLEON_PROVISION_LAYERS             | cloud-server  |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-cloud-legacy-galleon-pack:25.0.0.Beta1 |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value test-TEST on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value testpostgres on XPath //*[local-name()='driver']/@name

  Scenario: Test external driver created during s2i.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-custom with env and true using master
      | variable                     | value                                                       |
      | ENV_FILES                    | /opt/server/standalone/configuration/datasources.env |
      | DISABLE_BOOT_SCRIPT_INVOKER  | true |
      | GALLEON_PROVISION_LAYERS             | cloud-server  |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-cloud-legacy-galleon-pack:25.0.0.Beta1 |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value test-TEST on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value testpostgres on XPath //*[local-name()='driver']/@name
