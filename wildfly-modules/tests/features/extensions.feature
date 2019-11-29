@wildfly/wildfly-centos7
Feature: Wildfly extensions tests

  Scenario: Test preconfigure.sh
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_PRE_ADD_PROPERTY      | foo           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

   Scenario: Test preconfigure.sh fallback CLI
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_PRE_ADD_PROPERTY      | foo           |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain WFLYSRV0025
    Then container log should contain Configuring the server using embedded server
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

   Scenario: Test preconfigure.sh calls CLI
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_PRE_START_CLI_COMMAND | /system-property=foo:add(value=bar)           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value

   Scenario: Test preconfigure.sh calls CLI
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_PRE_START_CLI_COMMAND | /system-property=foo:add(value=bar)           |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain WFLYSRV0025
    Then container log should contain Configuring the server using embedded server
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test preconfigure.sh fails in bash
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_PRE_FAIL      | TEST_ERROR_MESSAGE |
    Then container log should not contain WFLYSRV0025
    Then container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

  Scenario: Test preconfigure.sh fails in bash
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_PRE_FAIL      | TEST_ERROR_MESSAGE |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should not contain WFLYSRV0025
    Then container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

  Scenario: Test preconfigure.sh fails in CLI script
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_PRE_CLI_FAIL  | rubbish       |
    Then container log should contain WFLYSRV0025
    Then container log should contain rubbish
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"
    And container log should contain Error, server failed to configure. Can't proceed with extensions

  Scenario: Test preconfigure.sh fails in CLI script
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_PRE_CLI_FAIL  | rubbish       |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    Then container log should contain rubbish
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

  Scenario: Test preconfigure.sh restart
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_PRE_CLI_RESTART  | true       |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And container log should contain Server has been shutdown and must be restarted.
    And container log should contain Restarting the server
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Test postconfigure.sh
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_POST_ADD_PROPERTY      | foo           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test postconfigure.sh
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_POST_ADD_PROPERTY      | foo           |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test postconfigure.sh calls CLI
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_POST_START_CLI_COMMAND | /system-property=foo:add(value=bar)           |
      | TEST_EXTENSION_POST_START_EMBEDDED_CLI_COMMAND | /system-property=foo2:add(value=bar2)           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value bar2 on XPath //*[local-name()='property' and @name="foo2"]/@value

  Scenario: Test postconfigure.sh calls CLI
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                             | value         |
      | TEST_EXTENSION_POST_START_EMBEDDED_CLI_COMMAND | /system-property=foo2:add(value=bar2)           |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value bar2 on XPath //*[local-name()='property' and @name="foo2"]/@value

  Scenario: Test postconfigure.sh fails in bash
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_POST_FAIL      | TEST_ERROR_MESSAGE |
    Then container log should contain WFLYSRV0025
    And container log should contain Shutdown server
    And container log should contain Shutting down in response to management operation 'shutdown'
    And container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

  Scenario: Test postconfigure.sh fails in bash
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_POST_FAIL      | TEST_ERROR_MESSAGE |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain Configuring the server using embedded server
    Then container log should not contain WFLYSRV0025
    And container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

 Scenario: Test postconfigure.sh fails in CLI script
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_POST_CLI_FAIL  | rubbish       |
    Then container log should contain WFLYSRV0025
    And container log should contain Shutdown server
    And container log should contain rubbish
    And container log should contain Shutting down in response to management operation 'shutdown'
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

  Scenario: Test postconfigure.sh fails in CLI script
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_POST_CLI_FAIL  | rubbish       |
      | EXECUTE_BOOT_SCRIPT_INVOKER | false |
    Then container log should contain Configuring the server using embedded server
    And container log should contain rubbish
    And container log should not contain WFLYSRV0010: Deployed "ROOT.war"

  Scenario: Test postconfigure.sh restart
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using master
      | variable                     | value         |
      | TEST_EXTENSION_POST_CLI_RESTART  | true       |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And container log should contain Server has been shutdown and must be restarted.
    And container log should contain Restarting the server
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |