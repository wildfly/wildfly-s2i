@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Some elytron testing

Scenario: Build elytron app
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-web-security with env and true using legacy-s2i-images
       | variable                   | value       |
       | GALLEON_PROVISION_LAYERS | datasources-web-server |
       | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:26.1.0.Beta1, org.wildfly.cloud:wildfly-cloud-galleon-pack:1.0.0.Beta4 |
     Then container log should contain WFLYSRV0025

 Scenario: check Elytron configuration with elytron core realms security domain fail
    When container integ- is started with env
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |
     Then container log should contain WFLYSRV0025
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value ApplicationDomain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain
     And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |

  Scenario: check Elytron configuration with elytron core realms security domain success
    When container integ- is started with command bash
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_CORE_REALM | true                 |    
    Then run /opt/server/bin/add-user.sh -a -u wildfly -p pass -g Admin -sc /opt/server/standalone/configuration in container once    
    And run sh -c '/opt/server/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | path                       | /test       |
      | port                       | 8080        |
      | username | wildfly |
      | password | pass |

 Scenario: check Elytron configuration with elytron custom security domain fail
    When container integ- is started with command bash
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | empty-foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | empty-foo-roles.properties                 |    
    Then copy features/image/scripts/security_domains/empty-foo-users.properties to /opt/server/standalone/configuration/ in container    
    Then copy features/image/scripts/security_domains/empty-foo-roles.properties to /opt/server/standalone/configuration/ in container    
    And run sh -c '/opt/server/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | expected_status_code       | 401         |
      | path                       | /test       |
      | port                       | 8080        |
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@name
    And XML file /opt/server/standalone/configuration/standalone.xml should contain value my-security-domain on XPath //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:undertow:')]/*[local-name()='application-security-domains']/*[local-name()='application-security-domain']/@security-domain

  Scenario: check Elytron configuration with elytron custom security domain success
    When container integ- is started with command bash
       | variable                   | value       |
       | ELYTRON_SECDOMAIN_NAME     | my-security-domain     |
       | ELYTRON_SECDOMAIN_USERS_PROPERTIES | foo-users.properties                 |
       | ELYTRON_SECDOMAIN_ROLES_PROPERTIES | foo-roles.properties                 |
    Then copy features/image/scripts/security_domains/foo-users.properties to /opt/server/standalone/configuration/ in container    
    Then copy features/image/scripts/security_domains/foo-roles.properties to /opt/server/standalone/configuration/ in container    
    And run sh -c '/opt/server/bin/openshift-launch.sh  > /tmp/boot.log 2>&1' in container and detach
    And file /tmp/boot.log should contain WFLYSRV0025
    And check that port 8080 is open
    And check that page is served
      | property                   | value       |
      | path                       | /test       |
      | port                       | 8080        |
      | username | wildfly |
      | password | pass |
