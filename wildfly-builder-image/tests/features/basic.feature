@wildfly/wildfly-s2i
Feature: Wildfly basic tests

  Scenario: Check that the legacy default config provisioned using galleon plugin works fine
   Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-default-config with env and True using main
   | variable                 | value           |
   | S2I_SERVER_DIR | server |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then container log should contain Running wildfly/wildfly-s2i
   Then container log should contain WFLYSRV0025

  Scenario:  Test ENV_FILES just to validate that there is no side effect
    When container integ- is started with command bash
    | variable | value |
    | ENV_FILES | /tmp/logging.env |
    Then copy features/image/scripts/logging.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Check if image version and release is printed on boot
   Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app with env and True using main
   | variable                 | value           |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then container log should contain Running wildfly/wildfly-s2i
   Then container log should contain WFLYSRV0025

  Scenario:  Test basic deployment
    When container integ- is started with env
     | variable                 | value           |
    Then container log should contain WFLYSRV0025
    Then container log should contain Using openshift launcher.
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
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value management-http-authentication on XPath  //*[local-name()='http-interface']/@http-authentication-factory
    Then file /opt/server/standalone/configuration/mgmt-users.properties should contain kabir
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='http-interface'][@security-realm="ManagementRealm"]
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value management-http-authentication on XPath  //*[local-name()='http-interface']/@http-authentication-factory
    And file /opt/wildfly/standalone/configuration/mgmt-users.properties should contain kabir
    

  Scenario: No admin user, Management interface should be kept secured with elytron, management console should be disabled
    When container integ- is started with env
       | variable                 | value           |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value management-http-authentication on XPath  //*[local-name()='http-interface']/@http-authentication-factory
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value false on XPath  //*[local-name()='http-interface']/@console-enabled
    And file /opt/server/standalone/configuration/mgmt-users.properties should not contain kabir

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

  Scenario: Proxy forwarding in galleon provisioned configuration using overriding env var
    When container integ- is started with command bash
       | variable                                            | value           |
       | SUBSYSTEM_UNDERTOW_SERVER_DEFAULT_SERVER_HTTP_LISTENER_DEFAULT__PROXY_ADDRESS_FORWARDING  | false            |
    Then copy features/image/scripts/proxy_address_forwarding.cli to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And run sh -c '/opt/server/bin/jboss-cli.sh --file=/tmp/proxy_address_forwarding.cli > /tmp/cli.log 2>&1' in container and detach
    And file /tmp/cli.log should contain PROXY ADDRESS FORWARDING IS false
  
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
    Then exactly 2 times container log should contain WFLYSRV0025
    And run sh -c 'kill -TERM 1' in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

  Scenario: Check if image does not shutdown with TERM signal when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    And run sh -c 'kill -TERM 1' in container and detach
    And container log should not contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down cleanly with TERM signal
    When container integ- is started with env
       | variable                  | value           |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    And run sh -c 'kill -TERM 1' in container and detach
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


  #JSON logging should have no effect on the configuration, server should start properly
  # although logging subsystem is not present in cloud-profile.

  Scenario: Test deployment in cloud-server server.
    When container integ- is started with env
      | variable                             | value          |
      | ENABLE_JSON_LOGGING                  | true           |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
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

  Scenario: Use Elytron for HTTPS
    When container integ- is started with env
      | variable                      | value                       |
      | HTTPS_PASSWORD                | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR            | /opt/server                    |
      | HTTPS_KEYSTORE                | keystore.jks                |
      | HTTPS_KEYSTORE_TYPE           | JKS                         |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value LocalhostSslContext on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@ssl-context
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='credential-reference']/@clear-text
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value JKS on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='implementation']/@type
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value /opt/server/keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='file']/@path

  Scenario: Use Elytron for HTTPS, relies on default keystore type
    When container integ- is started with env
      | variable                      | value                       |
      | HTTPS_PASSWORD                | p@ssw0rd                    |
      | HTTPS_KEYSTORE_DIR            | /opt/server                    |
      | HTTPS_KEYSTORE                | keystore.jks                |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='security-realm'][@name="ApplicationRealm"]/*[local-name()='server-identities']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value https on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@socket-binding
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value LocalhostSslContext on XPath //*[local-name()='server'][@name="default-server"]/*[local-name()='https-listener']/@ssl-context
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value p@ssw0rd on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name="LocalhostKeyStore"]/*[local-name()='credential-reference']/@clear-text
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

  Scenario:  Add server args
    When container integ- is started with env
    | variable | value  |
    | SERVER_ARGS | -Djava.foo=java.bar |
   Then container log should contain WFLYSRV0025
   And container log should contain -Djava.foo=java.bar

  Scenario:  Test CLI script execution at runtime, default output
    When container integ- is started with command bash
    | variable | value |
    | CLI_LAUNCH_SCRIPT | /tmp/script.cli |
    Then copy features/image/scripts/script.cli to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain Executing CLI script /tmp/script.cli during server startup
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo-absolute on XPath //*[local-name()='property']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar-absolute on XPath //*[local-name()='property']/@value
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario:  Test CLI script execution at runtime, custom output file
    When container integ- is started with command bash
    | variable | value |
    | CLI_LAUNCH_SCRIPT | /tmp/script.cli |
    | CLI_EXECUTION_OUTPUT | /tmp/my-cli-output.txt |
    Then copy features/image/scripts/script.cli to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain Executing CLI script /tmp/script.cli during server startup
    And file /tmp/my-cli-output.txt should contain Hi from absolute script
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo-absolute on XPath //*[local-name()='property']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar-absolute on XPath //*[local-name()='property']/@value
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario:  Test CLI script execution at runtime, absolute file and console output
    When container integ- is started with command bash
    | variable | value |
    | CLI_LAUNCH_SCRIPT | /tmp/script.cli |
    | CLI_EXECUTION_OUTPUT | CONSOLE |
    Then copy features/image/scripts/script.cli to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain Executing CLI script /tmp/script.cli during server startup
    And file /tmp/boot.log should contain Hi from absolute script
    And file /tmp/boot.log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo-absolute on XPath //*[local-name()='property']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar-absolute on XPath //*[local-name()='property']/@value
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario:  Test CLI script execution at runtime, failure
    When container integ- is started with command bash
    | variable | value |
    | CLI_LAUNCH_SCRIPT | /tmp/foo.cli |
    Then run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain ERROR /tmp/foo.cli doesn't exist

  Scenario:  Test interfaces  and statistics customization
    When container integ- is started with env
    | variable | value |
    | SERVER_PUBLIC_BIND_ADDRESS | 0.0.0.0 |
    | SERVER_MANAGEMENT_BIND_ADDRESS | 127.0.0.1 |
    | SERVER_ENABLE_STATISTICS | false |
    Then container log should contain -bmanagement 127.0.0.1
    Then container log should contain -b 0.0.0.0
    Then container log should contain -Dwildfly.statistics-enabled=false

  Scenario: Check default GC configuration
    When container integ- is started with env
    | variable  | value                      |
      Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:\+ExitOnOutOfMemoryError\s

  Scenario: Check GC_MIN_HEAP_FREE_RATIO GC configuration
    When container integ- is started with env
       | variable                         | value  |
       | GC_MIN_HEAP_FREE_RATIO           | 5      |
      Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=5\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_MAX_HEAP_FREE_RATIO GC configuration
    When container integ- is started with env
       | variable                         | value  |
       | GC_MAX_HEAP_FREE_RATIO           | 50     |
      Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=50\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_TIME_RATIO GC configuration
    When container integ- is started with env
       | variable                         | value  |
       | GC_TIME_RATIO                    | 5      |
      Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=5\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_ADAPTIVE_SIZE_POLICY_WEIGHT GC configuration
    When container integ- is started with env
       | variable                         | value  |
       | GC_ADAPTIVE_SIZE_POLICY_WEIGHT   | 80     |
      Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=80\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=96m\s

  Scenario: Check GC_METASPACE_SIZE and GC_MAX_METASPACE_SIZE GC configuration
    When container integ- is started with env
       | variable                 | value  |
       | GC_METASPACE_SIZE        | 60     |
       | GC_MAX_METASPACE_SIZE    | 120    |
      Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MinHeapFreeRatio=10\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxHeapFreeRatio=20\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:GCTimeRatio=4\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:AdaptiveSizePolicyWeight=90\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MetaspaceSize=60m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxMetaspaceSize=120m\s

  Scenario: Check for adjusted heap sizes
    When container integ- is started with args
      | arg       | value                                                    |
      | env_json  | {"JAVA_MAX_MEM_RATIO": 25, "JAVA_INITIAL_MEM_RATIO": 50} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:InitialRAMPercentage=50.0\s
      And container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxRAMPercentage=25.0\s

  # CLOUD-193 (mem-limit); CLOUD-459 (default heap size == max)
  Scenario: CLOUD-193 Check for dynamic resource allocation
    When container integ- is started with env
    | variable                 | value  |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxRAMPercentage=80.0\s
@wip
  # CLOUD-459 (override default heap size)
  Scenario: CLOUD-459 Check for adjusted default heap size
    When container integ- is started with args
      | arg       | value                         |
      | env_json  | {"INITIAL_HEAP_PERCENT": 0.5} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:InitialRAMPercentage=50.0\s

 Scenario: Check JAVA_DIAGNOSTICS disabled
    When container integ- is started with env
       | variable                 | value  |
    Then container log should not contain -XX:NativeMemoryTracking=summary

  Scenario: Check JAVA_DIAGNOSTICS
    When container integ- is started with env
       | variable                 | value  |
       | JAVA_DIAGNOSTICS        | true     |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:NativeMemoryTracking=summary\s

  Scenario:  Test ENV_FILES used to set logger category
    When container integ- is started with command bash
    | variable | value |
    | ENV_FILES | /tmp/logging.env |
    | LOGGER_CATEGORIES | com.foo.bar:TRACE,com.foo.bar.other:TRACE |
    Then copy features/image/scripts/logging.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value com.my.package on XPath //*[local-name()='logger']/@category
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value com.my.other.package on XPath //*[local-name()='logger']/@category
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value com.foo.bar on XPath //*[local-name()='logger']/@category
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value com.foo.bar.other on XPath //*[local-name()='logger']/@category
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario:  Test ENV_FILES used to set access_log
    When container integ- is started with command bash
    | variable | value |
    | ENV_FILES | /tmp/access_log.env |
    Then copy features/image/scripts/access_log.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value %h %l %u %t %{i,X-Forwarded-Host} "%r" %s %b on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@pattern
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@use-server-log
    And XML file /opt/server/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']/*[local-name()='level']/@name
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Add admin user to standard configuration with ENV_FILES
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/admin.env |
    Then copy features/image/scripts/admin.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='http-interface'][@security-realm="ManagementRealm"]
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value management-http-authentication on XPath  //*[local-name()='http-interface']/@http-authentication-factory
    And file /opt/server/standalone/configuration/mgmt-users.properties should contain kabir
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Set exploded deployment with ENV_FILES
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/scanner.env |
    Then copy features/image/scripts/scanner.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Set json logging with ENV_FILES
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/json_logging.env |
    Then copy features/image/scripts/json_logging.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then file /opt/server/standalone/configuration/logging.properties should contain handler.CONSOLE.formatter=OPENSHIFT
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value OPENSHIFT on XPath //*[local-name()='named-formatter']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value OPENSHIFT on XPath //*[local-name()='formatter']/@name
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Set mp-config with ENV_FILES
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/mp_config.env |
    Then copy features/image/scripts/mp_config.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value /home/jboss on XPath //*[local-name()='config-source' and @name='config-map']/*[local-name()='dir']/@path
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 88 on XPath //*[local-name()='config-source' and @name='config-map']/@ordinal
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Set messaging with ENV_FILES
    When container integ- is started with command bash
       | variable                 | value           |
       | ENV_FILES | /tmp/messaging.env |
    Then copy features/image/scripts/messaging.env to /tmp in container
    And run sh -c '/opt/jboss/container/wildfly/run/run  > /tmp/boot.log 2>&1' in container and detach
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/wf-app-amq7/ConnectionFactory on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ee:')]/*[local-name()='default-bindings']/@jms-connection-factory

   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value netty-remote-throughput on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='remote-connector']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value messaging-remote-throughput on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='remote-connector']/@socket-binding
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value activemq-ra-remote on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='pooled-connection-factory']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/JmsXA java:/RemoteJmsXA java:jboss/RemoteJmsXA java:/wf-app-amq7/ConnectionFactory on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='pooled-connection-factory']/@entries
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value netty-remote-throughput on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='pooled-connection-factory']/@connectors
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value xa on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='pooled-connection-factory']/@transaction
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value admin on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='pooled-connection-factory']/@user
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='pooled-connection-factory']/@password

   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='external-context']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value org.apache.activemq.artemis on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='external-context']/@module
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value javax.naming.InitialContext on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='external-context']/@class
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java.naming.provider.url on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value tcp://127.0.0.1:5678 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@value
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java.naming.factory.initial on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value org.apache.activemq.artemis.jndi.ActiveMQInitialContextFactory on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@value
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value queue.q1 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value q1 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@value
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value queue.q2 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value q2 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@value
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value queue.q3 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value q3 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='property']/@value    
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/q1 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext/q1 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@lookup
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/q2 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext/q2 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@lookup
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/q3 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext/q3 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@lookup
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/t1 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext/t1 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@lookup
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/t2 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext/t2 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@lookup
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:/t3 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value java:global/remoteContext/t3 on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:naming:')]//*[local-name()='lookup']/@lookup

   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value messaging-remote-throughput on XPath //*[local-name()='socket-binding-group']/*[local-name()='outbound-socket-binding']/@name
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 127.0.0.1 on XPath //*[local-name()='socket-binding-group']/*[local-name()='outbound-socket-binding']/*[local-name()='remote-destination']/@host
   Then XML file /opt/server/standalone/configuration/standalone.xml should contain value 5678 on XPath //*[local-name()='socket-binding-group']/*[local-name()='outbound-socket-binding']/*[local-name()='remote-destination']/@port
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |