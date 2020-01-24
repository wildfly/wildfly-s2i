@wildfly/wildfly-centos7
Feature: Wildfly s2i tests

  Scenario: Test cloud-server.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

  Scenario: Test jaxrs-server.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

  Scenario: Test datasources-web-server.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | datasources-web-server  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources-web-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

  Scenario: Test datasources-web-server,observability,keycloak
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | datasources-web-server,observability,keycloak  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources-web-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value keycloak on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

  Scenario: Test jaxrs-server,observability,keycloak
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,observability,keycloak  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value keycloak on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

  Scenario: Test cloud-server,keycloak
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,keycloak  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value keycloak on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name


  Scenario: Test cloud-server, exclude jaxrs
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-jaxrs  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  # Tests for specified exclusion

  Scenario: Test datasources-web-server, exclude datasources
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | datasources-web-server,-datasources  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources-web-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test jaxrs-server, exclude jpa
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,-jpa  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jpa on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test jaxrs-server, exclude datasources and jpa
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,-datasources,-jpa  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jpa on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test jaxrs-server, exclude jpa and datasources (meaningless order)
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,-jpa,-datasources  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jpa on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test jaxrs-server, exclude datasources, must fail
    Given failing s2i build git://github.com/openshift/openshift-jee-sample from . using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,-datasources |

  Scenario: Test jaxrs-server, exclude foo, must fail
    Given failing s2i build git://github.com/openshift/openshift-jee-sample from . using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,-foo |

  Scenario: Test cloud-server, exclude datasources and jpa
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-datasources,-jpa  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value datasources on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jpa on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test cloud-server, exclude observability
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-observability  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test cloud-server, exclude open-tracing
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-open-tracing  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value open-tracing on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test cloud-server, exclude open-tracing and observability
    Given failing s2i build git://github.com/openshift/openshift-jee-sample from . using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-open-tracing,-observability  |

  Scenario: Test jaxrs-server+observability, exclude open-tracing
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs with env and True using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,observability,-open-tracing  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value open-tracing on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  Scenario: Test jaxrs-server+observability, exclude open-tracing from provisioning.xml
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs-exclude with env and True using master
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value open-tracing on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

  # End specified tests

  Scenario: failing to build the example due to unknown layer being provisioned
    Given failing s2i build git://github.com/openshift/openshift-jee-sample from . using master
    | variable          | value                                                                                  |
    | GALLEON_PROVISION_LAYERS        | foo |

  Scenario: deploys the example, then checks if war file is deployed.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
    Then container log should contain WFLYSRV0025
    And container log should contain WFLYSRV0010: Deployed "ROOT.war"
    And file /opt/wildfly/standalone/deployments/ROOT.war should exist
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    And file /s2i-output/server should not exist
    And file /opt/jboss/container/wildfly/s2i/galleon/galleon-m2-repository should exist

  Scenario: Test deployment in default server, attempt to delete local maven repo, shouldn't be deleted
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
      | variable                | value|
      | MAVEN_CLEAR_REPO        | true |
    Then container log should contain WFLYSRV0025
    Then file /opt/jboss/container/wildfly/s2i/galleon/galleon-m2-repository should exist

  Scenario: Test deployment in slim jaxrs server, attempt to delete local maven repo, shouldn't be deleted
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-jaxrs-slim
      | variable                | value|
      | MAVEN_CLEAR_REPO        | true |
    Then container log should contain WFLYSRV0025
    Then file /opt/jboss/container/wildfly/s2i/galleon/galleon-m2-repository should exist
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    And file /s2i-output/server should not exist
    And s2i build log should contain Building Provision a provisioning.xml file

  Scenario:  Test deployment in fat default server, delete local maven repo
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
      | variable                             | value|
      | MAVEN_CLEAR_REPO                     | true |
      | GALLEON_PROVISION_DEFAULT_FAT_SERVER | true |
    Then container log should contain WFLYSRV0025
    Then file /opt/jboss/container/wildfly/s2i/galleon/galleon-m2-repository should not exist
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    And s2i build log should contain Building Provision a provisioning.xml file

  Scenario: Test force provisioning of default fat server, no copy to s2i_output
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
      | variable                             | value |
      | GALLEON_PROVISION_DEFAULT_FAT_SERVER | true  |
      | S2I_COPY_SERVER                      | false |
    Then container log should contain WFLYSRV0025
    And file /s2i-output/server should not exist
    And s2i build log should contain Building Provision a provisioning.xml file
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value mysql on XPath //*[local-name()='driver']/@name
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value postgresql on XPath //*[local-name()='driver']/@name

  Scenario: Test provisioning of default slim server
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
      | variable                             | value |
      | GALLEON_PROVISION_SERVER             | slim-default-server  |
    Then container log should contain WFLYSRV0025
    And file /s2i-output/server should not exist
    And s2i build log should contain Building Provision a provisioning.xml file

  Scenario: Test no incremental build, download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
    Then container log should contain WFLYSRV0025
    And s2i build log should contain Downloaded

  Scenario: Test incremental build, no download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and True using master
    Then container log should contain WFLYSRV0025
    And s2i build log should not contain Downloaded

  Scenario: Test galleon and app build, download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-galleon-incremental
     # Required to retrieve WF16 security-negociation-common 3.0.5 from nexus.
     | variable                             | value |
     | MAVEN_ARGS_APPEND                    | -Dcom.redhat.xpaas.repo.jbossorg  |
    Then s2i build log should contain Downloaded

  Scenario: Test galleon and app incremental build, no download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-galleon-incremental with env and True using master
    # Required to retrieve WF16 security-negociation-common 3.0.5 from nexus.
    | variable                             | value |
    | MAVEN_ARGS_APPEND                    | -Dcom.redhat.xpaas.repo.jbossorg  |
    Then s2i build log should not contain Downloaded

  Scenario: Test galleon build, download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-galleon-incremental
    # Required to retrieve WF16 security-negociation-common 3.0.5 from nexus.
    | variable                             | value |
    | MAVEN_ARGS_APPEND                    | -Dcom.redhat.xpaas.repo.jbossorg  |
    Then s2i build log should contain Downloaded

  Scenario: Test galleon incremental build, no download of artifacts
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-galleon-incremental with env and True using master
    # Required to retrieve WF16 security-negociation-common 3.0.5 from nexus.
    | variable                             | value |
    | MAVEN_ARGS_APPEND                    | -Dcom.redhat.xpaas.repo.jbossorg  |
    Then s2i build log should not contain Downloaded

  Scenario: Test galleon artifacts are retrieved from galleon local cache
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-share-galleon-artifacts
    Then container log should contain WFLYSRV0025
    And s2i build log should contain Downloaded: file:///opt/jboss/container/wildfly/s2i/galleon/galleon-m2-repository/org/wildfly/wildfly-galleon-pack/

  Scenario: Test deployment in cloud-profile, postgresql-driver, mysql-driver, core-server server, keycloak.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app
      | variable                             | value                                                              |
      | GALLEON_PROVISION_LAYERS             | cloud-profile,postgresql-driver,mysql-driver,core-server,keycloak  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value cloud-profile on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value postgresql-driver on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value mysql-driver on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value core-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/wildfly/.galleon/provisioning.xml should contain value keycloak on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

  Scenario: Test external driver created during s2i, slim server provisioned
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-custom with env and true using master
      | variable                     | value                                                 |
      | ENV_FILES                    | /opt/wildfly/standalone/configuration/datasources.env |
      | GALLEON_PROVISION_SERVER     | slim-default-server                                   |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value test-TEST on XPath //*[local-name()='datasource']/@pool-name
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value testpostgres on XPath //*[local-name()='driver']/@name

  Scenario: Test extension called at startup.
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-extension with env and true using master
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property' and @name="foo"]/@value

  Scenario: Test custom settings
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-settings with env and true using master
    Then container log should contain WFLYSRV0025
    Then file /home/jboss/.m2/settings.xml should contain foo-repository

  Scenario: Test custom settings with galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-settings with env and true using master
    | variable                     | value                                                 |
    | GALLEON_PROVISION_LAYERS     | cloud-server  |
    Then container log should contain WFLYSRV0025
    Then file /home/jboss/.m2/settings.xml should contain foo-repository

  Scenario: Test custom settings by env
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and true using master
     | variable                     | value                                                 |
     | MAVEN_SETTINGS_XML           | /home/jboss/../jboss/../jboss/.m2/settings.xml |
    Then s2i build log should contain /home/jboss/../jboss/../jboss/.m2/settings.xml
    Then container log should contain WFLYSRV0025

  Scenario: Test custom settings by env with galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and true using master
     | variable                     | value                                                 |
     | MAVEN_SETTINGS_XML           | /home/jboss/../jboss/../jboss/.m2/settings.xml |
     | GALLEON_PROVISION_LAYERS     | cloud-server  |
    Then s2i build log should contain /home/jboss/../jboss/../jboss/.m2/settings.xml
    Then container log should contain WFLYSRV0025