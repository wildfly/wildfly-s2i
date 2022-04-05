@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Wildfly Legacy s2i tests

  Scenario: Test provisioning.xml file
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/vanilla-wildfly/test-app-local-provisioning with env and True using main
      | variable                             | value         |
      | GALLEON_USE_LOCAL_FILE             | true  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario: Test preconfigure.sh
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using legacy-s2i-images
      | variable                             | value         |
      | TEST_EXTENSION_PRE_ADD_PROPERTY      | foo           |
      | GALLEON_PROVISION_LAYERS | cloud-server |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value


 Scenario: Test invalid layer
    Given failing s2i build http://github.com/openshift/openshift-jee-sample from . using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | foo |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |

  Scenario: Test default cloud config
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using legacy-s2i-images
      | variable                             | value         |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
      | GALLEON_PROVISION_LAYERS | cloud-default-config |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Test cloud-server, exclude jaxrs
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using legacy-s2i-images
      | variable                             | value         |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-jaxrs  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/server/.galleon/provisioning.xml should contain value jaxrs on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test preview FP and preview cloud FP with legacy app.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using legacy-s2i-images
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS | cloud-server |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-preview-feature-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-preview-cloud-galleon-pack:1.0.0.Beta4 |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario: Test external driver created during s2i.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-custom with env and true using legacy-s2i-images
      | variable                     | value                                                       |
      | ENV_FILES                    | /opt/server/standalone/configuration/datasources.env |
      | GALLEON_PROVISION_LAYERS             | cloud-server  |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
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
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-custom with env and true using legacy-s2i-images
      | variable                     | value                                                       |
      | ENV_FILES                    | /opt/server/standalone/configuration/datasources.env |
      | DISABLE_BOOT_SCRIPT_INVOKER  | true |
      | GALLEON_PROVISION_LAYERS             | cloud-server  |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
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
