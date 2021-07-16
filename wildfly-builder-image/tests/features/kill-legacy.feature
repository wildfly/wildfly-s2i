@wildfly/wildfly-s2i-jdk11
@wip
Feature: WildFly kill server only

  Scenario: Check if image version and release is printed on boot
   Given s2i build git://github.com/wildfly/wildfly-s2i from test/test-app with env and True using v2
   Then container log should contain Running wildfly/wildfly-s2i-jdk11 image, version
   Then container log should contain WFLYSRV0025

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
   Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
   Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then exactly 2 times container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --suspend-timeout=1" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050


Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 2 times container log should contain WFLYSRV0050


# VANILLA
 Scenario: Check if image version and release is printed on boot
   Given s2i build git://github.com/wildfly/wildfly-s2i from test/vanilla-wildfly/test-app with env and True using v2
   Then container log should contain Running wildfly/wildfly-s2i-jdk11 image, version

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

Scenario: Check if image shuts down with TERM signal
    When container integ- is started with env
      | variable              | value    |
      | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    And run kill -TERM 1 in container and detach
    And container log should contain received TERM signal
    And exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050

  Scenario: Check if image shuts down with cli when CLI_GRACEFUL_SHUTDOWN is set
    When container integ- is started with env
       | variable                  | value           |
       | CLI_GRACEFUL_SHUTDOWN     | true            |
       | JAVA_OPTS                               | -Xmx64m -Xms64m |
    Then container log should contain WFLYSRV0025
    Then run /opt/server/bin/jboss-cli.sh -c "shutdown --timeout=60" in container and detach
    Then container log should not contain received TERM signal
    Then exactly 1 times container log should contain WFLYSRV0050
