@wildfly/wildfly-centos7
Feature: WildFly Openshift security domains handling with elytron

  Scenario: check Elytron configuration with elytron core realms security domain fail
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
     Then container log should contain WFLYSRV0025
     And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
     And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
     And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |

  Scenario: check Elytron configuration with elytron core realms security domain success
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
    When container integ- is started with command bash
    Then run /opt/wildfly/bin/add-user.sh -a -u wildfly -p pass -g Admin -sc /opt/wildfly/standalone/configuration in container once    
    And run sh -c '/opt/wildfly/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | path                       | /test       |
      | port                       | 8080        |
      | username | wildfly |
      | password | pass |

  Scenario: check Elytron configuration with elytron core realms security domain fail, galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
       | GALLEON_PROVISION_LAYERS | datasources-web-server                 |
     Then container log should contain WFLYSRV0025
     And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
     And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |

  Scenario: check Elytron configuration with elytron core realms security domain success, galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
       | GALLEON_PROVISION_LAYERS | datasources-web-server                 |
    When container integ- is started with command bash
    Then run /opt/wildfly/bin/add-user.sh -a -u wildfly -p pass -g Admin -sc /opt/wildfly/standalone/configuration in container once    
    And run sh -c '/opt/wildfly/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | path                       | /test       |
      | port                       | 8080        |
      | username | wildfly |
      | password | pass |

 Scenario: check Elytron configuration with elytron custom security domain fail
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | empty-foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | empty-foo-roles.properties                 |
    When container integ- is started with command bash
    Then copy features/wildfly-s2i-modules/scripts/security_domains/empty-foo-users.properties to /opt/wildfly/standalone/configuration/ in container    
    Then copy features/wildfly-s2i-modules/scripts/security_domains/empty-foo-roles.properties to /opt/wildfly/standalone/configuration/ in container    
    And run sh -c '/opt/wildfly/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:ejb3:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain

  Scenario: check Elytron configuration with elytron custom security domain success
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | foo-roles.properties                 |
    When container integ- is started with command bash
    Then copy features/wildfly-s2i-modules/scripts/security_domains/foo-users.properties to /opt/wildfly/standalone/configuration/ in container    
    Then copy features/wildfly-s2i-modules/scripts/security_domains/foo-roles.properties to /opt/wildfly/standalone/configuration/ in container    
    And run sh -c '/opt/wildfly/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | path                       | /test       |
      | port                       | 8080        |
      | username | wildfly |
      | password | pass |

 Scenario: check Elytron configuration with elytron custom security domain fail, galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | empty-foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | empty-foo-roles.properties                 |
       | GALLEON_PROVISION_LAYERS | datasources-web-server                 |
    When container integ- is started with command bash
    Then copy features/wildfly-s2i-modules/scripts/security_domains/empty-foo-users.properties to /opt/wildfly/standalone/configuration/ in container    
    Then copy features/wildfly-s2i-modules/scripts/security_domains/empty-foo-roles.properties to /opt/wildfly/standalone/configuration/ in container    
    And run sh -c '/opt/wildfly/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
    And XML file /opt/wildfly/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain

  Scenario: check Elytron configuration with elytron custom security domain success, galleon
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images without running
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | foo-roles.properties                 |
       | GALLEON_PROVISION_LAYERS | datasources-web-server |
    When container integ- is started with command bash
    Then copy features/wildfly-s2i-modules/scripts/security_domains/foo-users.properties to /opt/wildfly/standalone/configuration/ in container    
    Then copy features/wildfly-s2i-modules/scripts/security_domains/foo-roles.properties to /opt/wildfly/standalone/configuration/ in container    
    And run sh -c '/opt/wildfly/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | path                       | /test       |
      | port                       | 8080        |
      | username | wildfly |
      | password | pass |
