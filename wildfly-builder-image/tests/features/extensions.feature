@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Wildfly extensions tests

  Scenario: Build server image
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-advanced-extensions with env and True using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025

  Scenario: Test preconfigure.sh
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_PRE_ADD_PROPERTY      | foo           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

   Scenario: Test preconfigure.sh fallback CLI
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_PRE_ADD_PROPERTY      | foo           |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain WFLYSRV0025
    Then container log should contain Configuring the server using embedded server
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

   Scenario: Test preconfigure.sh calls CLI
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_PRE_START_CLI_COMMAND | /system-property=foo:add(value=bar)           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value

   Scenario: Test preconfigure.sh calls CLI
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_PRE_START_CLI_COMMAND | /system-property=foo:add(value=bar)           |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain WFLYSRV0025
    Then container log should contain Configuring the server using embedded server
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test preconfigure.sh fails in bash
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_PRE_FAIL      | TEST_ERROR_MESSAGE |
    Then container log should not contain WFLYSRV0025
    Then container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

  Scenario: Test preconfigure.sh fails in bash
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_PRE_FAIL      | TEST_ERROR_MESSAGE |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should not contain WFLYSRV0025
    Then container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

  Scenario: Test preconfigure.sh fails in CLI script
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_PRE_CLI_FAIL  | rubbish       |
    Then container log should contain WFLYSRV0025
    Then container log should contain rubbish
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And container log should contain Error, server failed to configure. Can't proceed with custom extensions script

  Scenario: Test preconfigure.sh fails in CLI script
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_PRE_CLI_FAIL  | rubbish       |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    Then container log should contain rubbish
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

  Scenario: Test preconfigure.sh restart
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_PRE_CLI_RESTART  | true       |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And container log should contain Server has been shutdown and must be restarted.
    And container log should contain Restarting the server
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Test postconfigure.sh
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_POST_ADD_PROPERTY      | foo           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test postconfigure.sh
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_POST_ADD_PROPERTY      | foo           |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test postconfigure.sh calls CLI
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_POST_START_CLI_COMMAND | /system-property=foo:add(value=bar)           |
      | TEST_EXTENSION_POST_START_EMBEDDED_CLI_COMMAND | /system-property=foo2:add(value=bar2)           |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar2 on XPath //*[local-name()='property' and @name="foo2"]/@value

  Scenario: Test postconfigure.sh calls CLI
    When container integ- is started with env
      | variable                             | value         |
      | TEST_EXTENSION_POST_START_EMBEDDED_CLI_COMMAND | /system-property=foo2:add(value=bar2)           |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain Configuring the server using embedded server
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar2 on XPath //*[local-name()='property' and @name="foo2"]/@value

  Scenario: Test postconfigure.sh fails in bash
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_POST_FAIL      | TEST_ERROR_MESSAGE |
    Then container log should contain WFLYSRV0025
    And container log should contain Shutdown server
    And container log should contain Shutting down in response to management operation 'shutdown'
    And container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

  Scenario: Test postconfigure.sh fails in bash
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_POST_FAIL      | TEST_ERROR_MESSAGE |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain Configuring the server using embedded server
    Then container log should not contain WFLYSRV0025
    And container log should contain TEST_ERROR_MESSAGE
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

 Scenario: Test postconfigure.sh fails in CLI script
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_POST_CLI_FAIL  | rubbish       |
    Then container log should contain WFLYSRV0025
    And container log should contain Shutdown server
    And container log should contain rubbish
    And container log should contain Shutting down in response to management operation 'shutdown'
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

  Scenario: Test postconfigure.sh fails in CLI script
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_POST_CLI_FAIL  | rubbish       |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain Configuring the server using embedded server
    And container log should contain rubbish
    And container log should not contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")

  Scenario: Test postconfigure.sh restart
    When container integ- is started with env
      | variable                     | value         |
      | TEST_EXTENSION_POST_CLI_RESTART  | true       |
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "DemoApp.war" (runtime-name : "ROOT.war")
    And container log should contain Server has been shutdown and must be restarted.
    And container log should contain Restarting the server
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |