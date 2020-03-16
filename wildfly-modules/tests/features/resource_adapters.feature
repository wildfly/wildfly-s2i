@wildfly/wildfly-builder
Feature: WildFly Openshift resource adapters

  Scenario: Test resource adapter extension
    When container is started with env
       | variable                         | value                                                        |
       | RESOURCE_ADAPTERS                | TEST_1                                                       |
       | TEST_1_ID                        | fileQS                                                       |
       | TEST_1_MODULE_SLOT               | main                                                         |
       | TEST_1_MODULE_ID                 | org.jboss.teiid.resource-adapter.file                        |
       | TEST_1_CONNECTION_CLASS          | org.teiid.resource.adapter.file.FileManagedConnectionFactory |
       | TEST_1_CONNECTION_JNDI           | java:/marketdata-file                                        |
       | TEST_1_PROPERTY_ParentDirectory  | /home/jboss/source/injected/injected-files/data              |
       | TEST_1_PROPERTY_AllowParentPaths | true                                                         |
       | TEST_1_POOL_MIN_SIZE             | 1                                                            |
       | TEST_1_POOL_MAX_SIZE             | 5                                                            |
       | TEST_1_POOL_PREFILL              | false                                                        |
       | TEST_1_POOL_FLUSH_STRATEGY       | EntirePool                                                   |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value fileQS on XPath //*[local-name()='resource-adapter']/@id
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value org.jboss.teiid.resource-adapter.file on XPath //*[local-name()='resource-adapter']/*[local-name()='module']/@id
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value org.teiid.resource.adapter.file.FileManagedConnectionFactory on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/@class-name
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain trimmed value /home/jboss/source/injected/injected-files/data on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='config-property'][@name="ParentDirectory"]
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 1 on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='min-pool-size']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 5 on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='max-pool-size']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='prefill']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value EntirePool on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='flush-strategy']

  Scenario: Test resource adapter extension, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                         | value                                                        |
       | RESOURCE_ADAPTERS                | TEST_1                                                       |
       | TEST_1_ID                        | fileQS                                                       |
       | TEST_1_MODULE_SLOT               | main                                                         |
       | TEST_1_MODULE_ID                 | org.jboss.teiid.resource-adapter.file                        |
       | TEST_1_CONNECTION_CLASS          | org.teiid.resource.adapter.file.FileManagedConnectionFactory |
       | TEST_1_CONNECTION_JNDI           | java:/marketdata-file                                        |
       | TEST_1_PROPERTY_ParentDirectory  | /home/jboss/source/injected/injected-files/data              |
       | TEST_1_PROPERTY_AllowParentPaths | true                                                         |
       | TEST_1_POOL_MIN_SIZE             | 1                                                            |
       | TEST_1_POOL_MAX_SIZE             | 5                                                            |
       | TEST_1_POOL_PREFILL              | false                                                        |
       | TEST_1_POOL_FLUSH_STRATEGY       | EntirePool                                                   |
       | GALLEON_PROVISION_LAYERS         | cloud-server                                                 |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value fileQS on XPath //*[local-name()='resource-adapter']/@id
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value org.jboss.teiid.resource-adapter.file on XPath //*[local-name()='resource-adapter']/*[local-name()='module']/@id
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value org.teiid.resource.adapter.file.FileManagedConnectionFactory on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/@class-name
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain trimmed value /home/jboss/source/injected/injected-files/data on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='config-property'][@name="ParentDirectory"]
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 1 on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='min-pool-size']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 5 on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='max-pool-size']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='prefill']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value EntirePool on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='flush-strategy']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='security']/*[local-name()='elytron-enabled']
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='recovery']/*[local-name()='recover-credential']/*[local-name()='elytron-enabled']