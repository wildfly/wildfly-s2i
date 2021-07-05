@wildfly/wildfly-s2i-jdk11
Feature: Wildfly basic tests

  Scenario: Check that the legacy default config provisioned using galleon plugin works fine
   Given s2i build git://github.com/wildfly/wildfly-s2i from test/test-app-default-config with env and True using v2
   | variable                 | value           |
   | S2I_SERVER_DIR | server |
   Then container log should contain Running wildfly/wildfly-s2i-jdk11 image, version
   Then container log should contain WFLYSRV0025

  Scenario: Check if image version and release is printed on boot
   Given s2i build git://github.com/wildfly/wildfly-s2i from test/test-app with env and True using v2
   Then container log should contain Running wildfly/wildfly-s2i-jdk11 image, version
   Then container log should contain WFLYSRV0025

  Scenario:  Test basic deployment
    When container integ- is started with env
     | variable                 | value           |
    Then container log should contain WFLYSRV0025
    Then container log should contain Using legacy openshift launcher.
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Add admin user to standard configuration, galleon s2i
    When container integ- is started with env
       | variable                 | value           |
       | ADMIN_USERNAME           | kabir           |
       | ADMIN_PASSWORD           | pass            |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='http-interface'][@security-realm="ManagementRealm"]
    And file /opt/server/standalone/configuration/mgmt-users.properties should contain kabir

  Scenario: Make the Access Log Valve configurable
    When container integ- is started with env
      | variable          | value                 |
      | ENABLE_ACCESS_LOG | true                  |
    Then file /opt/server/standalone/configuration/standalone.xml should contain <access-log pattern="%h %l %u %t %{i,X-Forwarded-Host} &quot;%r&quot; %s %b" use-server-log="true"/>

  Scenario: Standard configuration with log handler enabled
    When container integ- is started with env
       | variable                   | value         |
       | ENABLE_ACCESS_LOG          | true          |
       | ENABLE_ACCESS_LOG_TRACE    | true          |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value %h %l %u %t %{i,X-Forwarded-Host} "%r" %s %b on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@pattern
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@use-server-log
    And XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']/*[local-name()='level']/@name

  Scenario: Add logging category, galleon s2i
    When container integ- is started with env
       | variable                   | value            |
       | LOGGER_CATEGORIES          | org.foo.bar:TRACE  |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='logger'][@category="org.foo.bar"]
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger'][@category="org.foo.bar"]/*[local-name()='level']/@name

  Scenario: Server started with OPENSHIFT_AUTO_DEPLOY_EXPLODED=true should work, galleon s2i
    When container integ- is started with env
       | variable                   | value            |
       | OPENSHIFT_AUTO_DEPLOY_EXPLODED       | true         |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded

  Scenario: Server started with OPENSHIFT_AUTO_DEPLOY_EXPLODED=false should work, galleon s2i
    When container integ- is started with env
       | variable                   | value            |
       | OPENSHIFT_AUTO_DEPLOY_EXPLODED       | false         |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded

  Scenario: Zero port offset in galleon provisioned configuration
    When container integ- is started with env
       | variable                    | value           |
       | PORT_OFFSET                 | 1000            |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 1000 on XPath //*[local-name()='socket-binding-group']/@port-offset

  Scenario: EJB headless service name
    When container integ- is started with env
      | variable                                    | value                     |
      | STATEFULSET_HEADLESS_SERVICE_NAME           | tx-server-headless        |
    Then container log should contain WFLYSRV0025
    And XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()="socket-binding"][@name="http"]/*[local-name()="client-mapping" and substring(@destination-address,string-length(@destination-address) - string-length("tx-server-headless") + 1) = "tx-server-headless"]
    And XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()="socket-binding"][@name="https"]/*[local-name()="client-mapping" and substring(@destination-address,string-length(@destination-address) - string-length("tx-server-headless") + 1) = "tx-server-headless"]

 Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable                                    | value                     |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container once
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

  Scenario: Check if image does not shutdown with TERM signal when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container once
    And container log should not contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container once
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down cleanly with TERM signal
    When container integ- is started with env
       | variable                  | value           |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container once
    And container log should contain received TERM signal
    And container log should contain WFLYSRV0241
    And exactly 2 times container log should contain WFLYSRV0050

Scenario:  Test execution of builder image and addition of json logging
    When container integ- is started with env
      | variable               | value |
      | ENABLE_JSON_LOGGING    | true  |
    Then container log should contain WFLYSRV0025
    Then container log should not contain Configuring the server using embedded server
    Then file /opt/server/standalone/configuration/logging.properties should contain handler.CONSOLE.formatter=OPENSHIFT
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value OPENSHIFT on XPath //*[local-name()='named-formatter']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value OPENSHIFT on XPath //*[local-name()='formatter']/@name
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Test fallback to CLI process launched for configuration
    When container integ- is started with env
      | variable               | value |
      | ENABLE_JSON_LOGGING    | true  |
      | DISABLE_BOOT_SCRIPT_INVOKER | true |
    Then container log should contain WFLYSRV0025
    Then container log should contain Configuring the server using embedded server
    Then file /opt/server/standalone/configuration/logging.properties should contain handler.CONSOLE.formatter=OPENSHIFT
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value OPENSHIFT on XPath //*[local-name()='named-formatter']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value OPENSHIFT on XPath //*[local-name()='formatter']/@name
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: No tracing
    When container integ- is started with env
       | variable                    | value             |
       | WILDFLY_TRACING_ENABLED     | false              |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]

  Scenario: Enable tracing
    When container integ- is started with env
       | variable                    | value             |
       | WILDFLY_TRACING_ENABLED     | true              |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]


  #JSON logging should have no effect on the configuration, server should start properly
  # although logging subsystem is not present in cloud-profile.
  # Disable opentracing present in cloud-profile observability

  Scenario: Test deployment in cloud-server server.
    When container integ- is started with env
      | variable                             | value          |
      | WILDFLY_TRACING_ENABLED              | false          |
      | ENABLE_JSON_LOGGING                  | true           |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='extension'][@module="org.wildfly.extension.microprofile.opentracing-smallrye"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:wildfly:microprofile-opentracing-smallrye:')]
    Then XML file /opt/server/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name

Scenario: CLOUD-2877, RHDM-520, RHPAM-1434, test default filter ref name, galleon
   When container integ- is started with env
      | variable                             | value         |
      | FILTERS                          | FOO        |
      | FOO_FILTER_RESPONSE_HEADER_NAME  | Foo-Header |
      | FOO_FILTER_RESPONSE_HEADER_VALUE | FOO        |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='host']/*[local-name()='filter-ref']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='filters']/*[local-name()='response-header']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value Foo-Header on XPath //*[local-name()='filters']/*[local-name()='response-header']/@header-name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value FOO on XPath //*[local-name()='filters']/*[local-name()='response-header']/@header-value

Scenario: Configure HTTPS, galleon s2i
    When container integ- is started with env
      | variable                           | value                       |
      | HTTPS_PASSWORD                 | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR             | /opt/server                    |
      | HTTPS_KEYSTORE                 | keystore.jks                |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value /opt/server/keystore.jks on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']/*[local-name()='ssl']/*[local-name()='keystore']/@path
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']/*[local-name()='ssl']/*[local-name()='keystore']/@keystore-password
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value ApplicationRealm on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@security-realm

  Scenario: Use Elytron for HTTPS
    When container integ- is started with env
      | variable                      | value                       |
      | HTTPS_PASSWORD                | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR            | /opt/server                    |
      | HTTPS_KEYSTORE                | keystore.jks                |
      | HTTPS_KEYSTORE_TYPE           | JKS                         |
      | CONFIGURE_ELYTRON_SSL         | true                        |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value LocalhostSslContext on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@ssl-context
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='credential-reference']/@clear-text
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value JKS on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='implementation']/@type
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value /opt/server/keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='file']/@path

 Scenario: Micro-profile config configuration, galleon s2i
    When container integ- is started with env
       | variable                                | value           |
       | MICROPROFILE_CONFIG_DIR                 | /home/jboss     |
       | MICROPROFILE_CONFIG_DIR_ORDINAL         | 88              |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value /home/jboss on XPath //*[local-name()='config-source' and @name='config-map']/*[local-name()='dir']/@path
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 88 on XPath //*[local-name()='config-source' and @name='config-map']/@ordinal

Scenario: Test resource adapter extension, galleon s2i
    When container integ- is started with env
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
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value fileQS on XPath //*[local-name()='resource-adapter']/@id
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value org.jboss.teiid.resource-adapter.file on XPath //*[local-name()='resource-adapter']/*[local-name()='module']/@id
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value org.teiid.resource.adapter.file.FileManagedConnectionFactory on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/@class-name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain trimmed value /home/jboss/source/injected/injected-files/data on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='config-property'][@name="ParentDirectory"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 1 on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='min-pool-size']
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 5 on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='max-pool-size']
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='prefill']
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value EntirePool on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='pool']/*[local-name()='flush-strategy']
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='security']/*[local-name()='elytron-enabled']
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='resource-adapter']/*[local-name()='connection-definitions']/*[local-name()='connection-definition']/*[local-name()='recovery']/*[local-name()='recover-credential']/*[local-name()='elytron-enabled']