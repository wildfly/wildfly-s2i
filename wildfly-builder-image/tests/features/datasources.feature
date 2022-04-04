@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Wildfly configured for datasources

  Scenario: Build image with server
    Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-postgresql-mysql with env and true using main
    | variable                 | value           |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025

  Scenario:  Test addition of datasource
     When container integ- is started with env
      | variable                     | value                                         |
      | DB_SERVICE_PREFIX_MAPPING    | TEST-postgresql=test                          |
      | TEST_POSTGRESQL_SERVICE_HOST | localhost                                     |
      | TEST_POSTGRESQL_SERVICE_PORT | 5432                                          |
      | test_DATABASE                | demo                                          |
      | test_JNDI                    | java:jboss/datasources/test-postgresql        |
      | test_JTA                     | false                                         |
      | test_NONXA                   | true                                          |
      | test_PASSWORD                | demo                                          |
      | test_URL                     | jdbc:postgresql://localhost:5432/postgresdb   |
      | test_USERNAME                | demo                                          |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value test_postgresql-test on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value MySQLDS on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value PostgreSQLDS on XPath //*[local-name()='datasource']/@pool-name
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Test dirver added during provisioning.
     When container integ- is started with env
      | variable                     | value                                                       |
      | ENV_FILES                    | /opt/server/standalone/configuration/datasources.env |
      | POSTGRESQL_ENABLED | false |
      | MYSQL_ENABLED            | false |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value test-TEST on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value postgresql on XPath //*[local-name()='driver']/@name

  Scenario: Test external driver created during s2i.
     When container integ- is started with env
      | variable                     | value                                                       |
      | ENV_FILES                    | /opt/server/standalone/configuration/datasources.env |
      | POSTGRESQL_ENABLED | false |
      | MYSQL_ENABLED            | false |
      | DISABLE_BOOT_SCRIPT_INVOKER  | true |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value test-TEST on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value postgresql on XPath //*[local-name()='driver']/@name