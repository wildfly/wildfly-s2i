@wildfly/wildfly-s2i
Feature: Wildfly stability related tests

  Scenario: Check that the server starts properly at the preview stability level
   Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-stability-preview with env and True using main
   | variable    |        value        |
   | SERVER_ARGS | --stability=preview |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then container log should contain WFLYSRV0025
