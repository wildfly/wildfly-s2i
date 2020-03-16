@wildfly/wildfly-builder
Feature: Openshift mp-config tests

  Scenario: Micro-profile config configuration, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                                | value           |
       | MICROPROFILE_CONFIG_DIR                 | /home/jboss     |
       | MICROPROFILE_CONFIG_DIR_ORDINAL         | 88              |
       | GALLEON_PROVISION_LAYERS                | cloud-profile   |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value /home/jboss on XPath //*[local-name()='config-source' and @name='config-map']/*[local-name()='dir']/@path
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 88 on XPath //*[local-name()='config-source' and @name='config-map']/@ordinal

  Scenario: Micro-profile config, configuration with defaults
    When container is started with env
       | variable                                | value         |
       | MICROPROFILE_CONFIG_DIR                 | /home/jboss   |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value /home/jboss on XPath //*[local-name()='config-source'][@name='config-map']/*[local-name()='dir']/@path
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 500 on XPath //*[local-name()='config-source' and @name='config-map']/@ordinal
