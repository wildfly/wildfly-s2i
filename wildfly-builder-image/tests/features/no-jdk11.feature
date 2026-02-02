@wildfly/wildfly-s2i
Feature: Wildfly Legacy s2i tests that can't run on JDK11

  Scenario: Test preview FP and preview cloud FP with legacy app.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using legacy-s2i-images
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS | cloud-server |
      | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-preview-feature-pack:39.0.0.Final, org.wildfly.cloud:wildfly-preview-cloud-galleon-pack:9.0.0.Final |
   Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
