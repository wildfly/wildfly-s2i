@wildfly/wildfly-centos7
Feature: Wildfly basic tests

  Scenario: Check if image version and release is printed on boot
    When container is ready
    Then container log should contain Running wildfly/wildfly-centos7 image, version

  Scenario: Add admin user to standard configuration
    When container is started with env
       | variable       | value           |
       | ADMIN_USERNAME | kabir           |
       | ADMIN_PASSWORD | pass            |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value ManagementRealm on XPath //*[local-name()='http-interface']/@security-realm
    And file /opt/wildfly/standalone/configuration/mgmt-users.properties should contain kabir

  Scenario: Add admin user to standard configuration, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                 | value           |
       | ADMIN_USERNAME           | kabir           |
       | ADMIN_PASSWORD           | pass            |
       | GALLEON_PROVISION_LAYERS | jaxrs-server     |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should have 0 elements on XPath  //*[local-name()='http-interface'][@security-realm="ManagementRealm"]
    And file /opt/wildfly/standalone/configuration/mgmt-users.properties should contain kabir

  Scenario: Make the Access Log Valve configurable
    When container is started with env
      | variable          | value                 |
      | ENABLE_ACCESS_LOG | true                  |
    Then file /opt/wildfly/standalone/configuration/standalone.xml should contain <access-log pattern="%h %l %u %t %{i,X-Forwarded-Host} &quot;%r&quot; %s %b" use-server-log="true"/>

  Scenario: Standard configuration with log handler enabled
    When container is started with env
       | variable                   | value         |
       | ENABLE_ACCESS_LOG          | true          |
       | ENABLE_ACCESS_LOG_TRACE    | true          |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value %h %l %u %t %{i,X-Forwarded-Host} "%r" %s %b on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@pattern
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@use-server-log
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']/*[local-name()='level']/@name


  Scenario: Standard configuration with log handler enabled
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                   | value         |
       | ENABLE_ACCESS_LOG          | true          |
       | ENABLE_ACCESS_LOG_TRACE    | true          |
       | GALLEON_PROVISION_LAYERS   | datasources-web-server     |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value %h %l %u %t %{i,X-Forwarded-Host} "%r" %s %b on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@pattern
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='server' and @name='default-server']/*[local-name()='host' and @name='default-host']/*[local-name()='access-log']/@use-server-log
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger' and @category='org.infinispan.rest.logging.RestAccessLoggingHandler']/*[local-name()='level']/@name

  Scenario: Add logging category
    When container is started with env
       | variable                   | value            |
       | LOGGER_CATEGORIES          | org.foo.bar:TRACE  |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='logger'][@category="org.foo.bar"]
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger'][@category="org.foo.bar"]/*[local-name()='level']/@name

  Scenario: Add logging category, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                   | value            |
       | GALLEON_PROVISION_LAYERS   | cloud-server      |
       | LOGGER_CATEGORIES          | org.foo.bar:TRACE  |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should have 1 elements on XPath  //*[local-name()='logger'][@category="org.foo.bar"]
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value TRACE on XPath //*[local-name()='logger'][@category="org.foo.bar"]/*[local-name()='level']/@name


  Scenario: Server started with AUTO_DEPLOY_EXPLODED=true should work
    When container is started with env
       | variable                   | value         |
       | AUTO_DEPLOY_EXPLODED       | true          |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded

  Scenario: Server started with AUTO_DEPLOY_EXPLODED=false should work
    When container is started with env
       | variable                   | value         |
       | AUTO_DEPLOY_EXPLODED       | false         |
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded

  Scenario: Server started with OPENSHIFT_AUTO_DEPLOY_EXPLODED=true should work, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                   | value            |
       | GALLEON_PROVISION_LAYERS   | cloud-server      |
       | OPENSHIFT_AUTO_DEPLOY_EXPLODED       | true         |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded

  Scenario: Server started with OPENSHIFT_AUTO_DEPLOY_EXPLODED=false should work, galleon s2i
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                   | value            |
       | GALLEON_PROVISION_LAYERS   | cloud-server      |
       | OPENSHIFT_AUTO_DEPLOY_EXPLODED       | false         |
    Then container log should contain WFLYSRV0025:
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value false on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:deployment-scanner:')]/*[local-name()='deployment-scanner' and not(@name)]/@auto-deploy-exploded

  Scenario: Zero port offset
    When container is started with env
       | variable                    | value           |
       | PORT_OFFSET                 | 1000            |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 1000 on XPath //*[local-name()='socket-binding-group']/@port-offset

  Scenario: Zero port offset in galleon provisioned configuration
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
       | variable                    | value           |
       | PORT_OFFSET                 | 1000            |
       | GALLEON_PROVISION_LAYERS    | jaxrs-server      |
    Then container log should contain WFLYSRV0025
    Then XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value 1000 on XPath //*[local-name()='socket-binding-group']/@port-offset

  Scenario: EJB headless service name
    When container is started with env
      | variable                                    | value                     |
      | STATEFULSET_HEADLESS_SERVICE_NAME           | tx-server-headless        |
    Then container log should contain WFLYSRV0025
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()="socket-binding"][@name="http"]/*[local-name()="client-mapping" and substring(@destination-address,string-length(@destination-address) - string-length("tx-server-headless") + 1) = "tx-server-headless"]
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should have 1 elements on XPath //*[local-name()="socket-binding"][@name="https"]/*[local-name()="client-mapping" and substring(@destination-address,string-length(@destination-address) - string-length("tx-server-headless") + 1) = "tx-server-headless"]
