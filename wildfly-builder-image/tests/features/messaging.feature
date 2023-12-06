@wildfly/wildfly-s2i
Feature: Wildfly messaging tests

Scenario: Configure amq7 remote broker
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app with env and true using legacy-s2i-images
    | variable              | value                                   |
    | GALLEON_PROVISION_LAYERS             | cloud-server  |
    | GALLEON_PROVISION_FEATURE_PACKS | org.wildfly:wildfly-galleon-pack:30.0.1.Final, org.wildfly.cloud:wildfly-cloud-galleon-pack:5.0.2.Final |
    | MQ_SERVICE_PREFIX_MAPPING           | wf-app-amq7=TEST |
    | WF_APP_AMQ_TCP_SERVICE_HOST      | 127.0.0.1 |
    | WF_APP_AMQ_TCP_SERVICE_PORT       | 5678 |
    | TEST_USERNAME                                    | admin |
    | TEST_PASSWORD                                   | foo |
    | TEST_QUEUES                                         | q1,q2,q3 |
    | TEST_TOPICS                                           | t1,t2,t3 |
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
   Then container log should contain WFLYSRV0025

 Scenario: deploys the test-app-mdb app, then checks if it's deployed properly with Queues and Topics added
    Given s2i build https://github.com/wildfly/wildfly-s2i from test/test-app-mdb using main
    | variable              | value                                   |
    |  MQ_TOPICS       |  HELLOWORLDMDBTopic   |
    | MQ_QUEUES      | HELLOWORLDMDBQueue |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###

    Then container log should contain Started message driven bean 'HelloWorldQueueMDB' with 'activemq-ra.rar' resource adapter
    Then container log should contain Started message driven bean 'HelloWorldQTopicMDB' with 'activemq-ra.rar' resource adapter
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value default on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='server']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value HELLOWORLDMDBQueue on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='server']/*[local-name()='jms-queue']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value /queue/HELLOWORLDMDBQueue on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='server']/*[local-name()='jms-queue']/@entries
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value HELLOWORLDMDBTopic on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='server']/*[local-name()='jms-topic']/@name
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value /topic/HELLOWORLDMDBTopic on XPath  //*[local-name()='subsystem' and starts-with(namespace-uri(), 'urn:jboss:domain:messaging-activemq:')]/*[local-name()='server']/*[local-name()='jms-topic']/@entries
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /HelloWorldMDBServletClient     |
      | port     | 8080  |
   Then container log should contain Received Message from queue: This is message 1