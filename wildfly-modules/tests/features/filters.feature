@wildfly/wildfly-builder
Feature: WildFly Openshift filters

  Scenario: CLOUD-2877, RHDM-520, RHPAM-1434, test default filter ref name
    When container is started with env
      | variable                         | value      |
      | FILTERS                          | FOO        |
      | FOO_FILTER_RESPONSE_HEADER_NAME  | Foo-Header |
      | FOO_FILTER_RESPONSE_HEADER_VALUE | FOO        |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='host']/*[local-name()='filter-ref']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='filters']/*[local-name()='response-header']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='filters']/*[local-name()='response-header']/@header-name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value FOO on XPath //*[local-name()='filters']/*[local-name()='response-header']/@header-value


Scenario: CLOUD-2877, RHDM-520, RHPAM-1434, test default filter ref name, galleon
   Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server  |
      | FILTERS                          | FOO        |
      | FOO_FILTER_RESPONSE_HEADER_NAME  | Foo-Header |
      | FOO_FILTER_RESPONSE_HEADER_VALUE | FOO        |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='host']/*[local-name()='filter-ref']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='filters']/*[local-name()='response-header']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='filters']/*[local-name()='response-header']/@header-name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value FOO on XPath //*[local-name()='filters']/*[local-name()='response-header']/@header-value
