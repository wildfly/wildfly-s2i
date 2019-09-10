@wildfly/wildfly-centos7
Feature: Wildfly basic tests

  Scenario: Check if image version and release is printed on boot
    When container is ready
    Then container log should contain Running wildfly/wildfly-centos7 image, version