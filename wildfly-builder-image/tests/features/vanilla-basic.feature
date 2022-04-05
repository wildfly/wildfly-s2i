@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Vanilla Wildfly basic tests

 Scenario: Check if image version and release is printed on boot
   Given s2i build http://github.com/wildfly/wildfly-s2i from test/vanilla-wildfly/test-app with env and True using main
   | variable                             | value         |
   ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
   Then container log should contain Running wildfly/wildfly-s2i-jdk

Scenario:  Test basic deployment vanilla WildFly
    When container integ- is started with env
    | variable                    | value           |
    Then container log should contain WFLYSRV0025
    Then container log should contain Using standalone launcher.
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario: Zero port offset in galleon provisioned configuration with vanilla wildfly
    When container integ- is started with env
       | variable                    | value           |
       | PORT_OFFSET                 | 1000            |
    Then container log should contain WFLYSRV0025
    And container log should contain -Djboss.socket.binding.port-offset=1000

# CLOUD-427: we need to ensure jboss.node.name doesn't go beyond 23 chars
  Scenario: Check that long node names are truncated to 23 characters
    When container integ- is started with env
       | variable  | value                      |
       | NODE_NAME | abcdefghijklmnopqrstuvwxyz |
    Then container log should contain -Djboss.node.name=defghijklmnopqrstuvwxyz

  Scenario: Check that node name is used
    When container integ- is started with env
       | variable  | value                      |
       | NODE_NAME | abcdefghijk                |
    Then container log should contain -Djboss.node.name=abcdefghijk

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
      | mem_limit | 1073741824                                               |
      | env_json  | {"JAVA_MAX_MEM_RATIO": 25, "JAVA_INITIAL_MEM_RATIO": 50} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -Xms128m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -Xmx256m\s

  # CLOUD-193 (mem-limit); CLOUD-459 (default heap size == max)
  Scenario: CLOUD-193 Check for dynamic resource allocation
    When container integ- is started with args
      | arg                    | value             |
      | mem_limit              | 1073741824        |
    Then container log should match regex ^ *JAVA_OPTS: *.* -Xms128m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -Xmx512m\s

  # CLOUD-459 (override default heap size)
  Scenario: CLOUD-459 Check for adjusted default heap size
    When container integ- is started with args
      | arg       | value                         |
      | mem_limit | 1073741824                    |
      | env_json  | {"INITIAL_HEAP_PERCENT": 0.5} |
    Then container log should match regex ^ *JAVA_OPTS: *.* -Xms256m\s
      And container log should match regex ^ *JAVA_OPTS: *.* -Xmx512m\s

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run sh -c 'kill -TERM 1' in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image does not shutdown with TERM signal when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run sh -c 'kill -TERM 1' in container and detach
    And container log should not contain received TERM signal
    And container log should not contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down cleanly with TERM signal
    When container integ- is started with env
    | variable                  | value           |
     | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run sh -c 'kill -TERM 1' in container and detach
    And container log should contain received TERM signal
    And container log should contain WFLYSRV0241
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Test to ensure that maven is run with -Djava.net.preferIPv4Stack=true and user-supplied arguments, even when MAVEN_ARGS is overridden, and doesn't clear the local repository after the build
    Given s2i build http://github.com/wildfly/wildfly-s2i from test/vanilla-wildfly/test-app with env and true using main
       | variable          | value                                                                                  |
       | MAVEN_ARGS        | -e -Dcom.redhat.xpaas.repo.jbossorg -DskipTests package -Popenshift |
       | MAVEN_ARGS_APPEND | -Dfoo=bar                                                                              |
    Then container log should contain WFLYSRV0025
    And run sh -c 'test -d /tmp/artifacts/m2/org && echo all good' in container and immediately check its output for all good
    And s2i build log should contain -Djava.net.preferIPv4Stack=true
    And s2i build log should contain -Dfoo=bar
    And s2i build log should contain -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -XX:+ExitOnOutOfMemoryError

Scenario:  Override default launcher
    When container integ- is started with env
    | variable                                                   | value           |
    | SERVER_LAUNCH_SCRIPT_OVERRIDE | standalone.sh |
   Then container log should contain WFLYSRV0025
   And container log should contain Using custom launcher standalone.sh

Scenario:  Add server args, starts in admin mode.
    When container integ- is started with env
    | variable                                                   | value           |
    | SERVER_ARGS | --start-mode=admin-only |
    | JAVA_OPTS_APPEND | -Djava.foo=java.bar |
   Then container log should contain WFLYSRV0025
   And container log should contain --start-mode=admin-only
   And container log should contain -Djava.foo=java.bar

Scenario:  Test CLI script execution at runtime
    When container integ- is started with env
    | variable                    | value           |
    | CLI_LAUNCH_SCRIPT | myscript.cli |
    Then container log should contain Executing CLI script /opt/server/myscript.cli during server startup
    Then container log should contain CLI execution output redirected to /tmp/server-cli-execution-output-file.txt
    Then container log should contain WFLYSRV0025
    And file /tmp/server-cli-execution-output-file.txt should contain Hi from CLI
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property']/@value
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario:  Test CLI script execution at runtime
    When container integ- is started with env
    | variable                    | value           |
    | CLI_LAUNCH_SCRIPT | myscript.cli |
    | CLI_EXECUTION_OUTPUT | CONSOLE |
    Then container log should contain Executing CLI script /opt/server/myscript.cli during server startup
    Then container log should contain CLI execution output displayed in the console
    Then container log should contain Hi from CLI
    Then container log should contain WFLYSRV0025
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property']/@value
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario:  Test CLI script execution at runtime, custom output file
    When container integ- is started with env
    | variable                    | value           |
    | CLI_LAUNCH_SCRIPT | myscript.cli |
    | CLI_EXECUTION_OUTPUT | /tmp/my-cli-output.txt |
    Then container log should contain Executing CLI script /opt/server/myscript.cli during server startup
    Then container log should contain CLI execution output redirected to /tmp/my-cli-output.txt
    Then container log should contain WFLYSRV0025
    And file /tmp/my-cli-output.txt should contain Hi from CLI
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value foo on XPath //*[local-name()='property']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value bar on XPath //*[local-name()='property']/@value
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario:  Test CLI script execution at runtime, absolute file and console output
    When container integ- is started with command bash
    | variable                    | value           |
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
    | variable                    | value           |
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