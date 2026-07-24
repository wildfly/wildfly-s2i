@wildfly/wildfly-s2i
Feature: Wildfly basic tests 2

  Scenario: Check if image version and release is printed on boot
   Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app with env and True using main
   | variable                 | value           |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then container log should contain Running wildfly/wildfly-s2i
   Then container log should contain WFLYSRV0025

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
      | env_json  | {"JAVA_MAX_MEM_RATIO": 25} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxRAMPercentage=25.0\s

  # CLOUD-193 (mem-limit); CLOUD-459 (default heap size == max)
  Scenario: CLOUD-193 Check for dynamic resource allocation
    When container integ- is started with env
    | variable                 | value  |
    Then container log should match regex ^ *JAVA_OPTS: *.* -XX:MaxRAMPercentage=80.0\s

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
    Then file /tmp/boot.log should contain WFLYSRV0025
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
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

  Scenario: Check that system properties are set by default
    When container integ- is started with env
     | variable                 | value           |
    Then container log should contain -Djboss.node.name=
    Then container log should contain -Djboss.tx.node.id=
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value ${jboss.tx.node.id:1} on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:transactions:')]//*[local-name()='core-environment']/@node-identifier

# CLOUD-4173: we need to ensure jboss.tx.node.id doesn't go beyond 23 chars
  Scenario: Check that long node names are truncated to 23 characters for the jboss.tx.node.id property
    When container integ- is started with env
       | variable  | value                      |
       | NODE_NAME | abcdefghijklmnopqrstuvwxyz |
    Then container log should contain -Djboss.node.name=abcdefghijklmnopqrstuvwxyz -Djboss.tx.node.id=defghijklmnopqrstuvwxyz

  Scenario: Check that node name is used
    When container integ- is started with env
       | variable  | value                      |
       | NODE_NAME | abcdefghijk                |
    Then container log should contain -Djboss.node.name=abcdefghijk -Djboss.tx.node.id=abcdefghijk

  Scenario: Check that long node names are truncated to 23 characters for the jboss.tx.node.id property
    When container integ- is started with env
       | variable  | value                      |
       | JBOSS_NODE_NAME | abcdefghijklmnopqrstuvwxyz |
    Then container log should contain -Djboss.node.name=abcdefghijklmnopqrstuvwxyz -Djboss.tx.node.id=defghijklmnopqrstuvwxyz

  Scenario: Check that node name is used
    When container integ- is started with env
       | variable  | value                      |
       | JBOSS_NODE_NAME | abcdefghijk                |
    Then container log should contain -Djboss.node.name=abcdefghijk -Djboss.tx.node.id=abcdefghijk