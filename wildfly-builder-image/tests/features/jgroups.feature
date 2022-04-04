@wildfly/wildfly-s2i-jdk17
@wildfly/wildfly-s2i-jdk11
Feature: Openshift WildFly jgroups

  Scenario: Build server image
    Given s2i build http://github.com/wildfly/wildfly-s2i from test/test-app-clustering with env and true using main
    | variable                             | value         |
    ### PLACEHOLDER FOR CLOUD CUSTOM TESTING ###
    Then container log should contain WFLYSRV0025:

  # CLOUD-336
  Scenario: Check if jgroups is secure
    When container integ- is started with env
       | variable                 | value    |
       | JGROUPS_CLUSTER_PASSWORD | asdfasdf |
       | JGROUPS_PING_PROTOCOL               | openshift.DNS_PING                      |
       |OPENSHIFT_DNS_PING_SERVICE_NAME    | foo |
    Then container log should contain WFLYSRV0025:
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='auth-protocol'][@type='AUTH']

  Scenario: Check jgroups encryption does not create invalid configuration with missing name
    When container integ- is started with env
       | variable                                     | value                                  |
       | JGROUPS_ENCRYPT_SECRET                       | jdg_jgroups_encrypt_secret             |
       | JGROUPS_ENCRYPT_KEYSTORE_DIR                 | /etc/jgroups-encrypt-secret-volume     |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                           |
       | JGROUPS_ENCRYPT_PASSWORD                     | mykeystorepass                         |
       | JGROUPS_PING_PROTOCOL                        | openshift.DNS_PING                     |
       |OPENSHIFT_DNS_PING_SERVICE_NAME    | foo |
    Then container log should contain WFLYSRV0025:
     And available container log should contain WARN Detected partial JGroups encryption configuration, the communication within the cluster WILL NOT be encrypted.

  Scenario: Check jgroups encryption does not create invalid configuration with missing password
    When container integ- is started with env
       | variable                                     | value                                  |
       | JGROUPS_ENCRYPT_SECRET                       | jdg_jgroups_encrypt_secret             |
       | JGROUPS_ENCRYPT_KEYSTORE_DIR                 | /etc/jgroups-encrypt-secret-volume     |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                           |
       | JGROUPS_ENCRYPT_NAME                         | jboss                                  |
       | JGROUPS_PING_PROTOCOL                        | openshift.DNS_PING                     |
       |OPENSHIFT_DNS_PING_SERVICE_NAME    | foo |
    Then container log should contain WFLYSRV0025:
     And available container log should contain WARN Detected partial JGroups encryption configuration, the communication within the cluster WILL NOT be encrypted.

Scenario: jgroups-encrypt
    When container integ- is started with env
       | variable                                     | value                                  |
       | JGROUPS_ENCRYPT_SECRET                       | wildfly_jgroups_encrypt_secret             |
       | JGROUPS_ENCRYPT_KEYSTORE_DIR                 | /etc/jgroups-encrypt-secret-volume     |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                           |
       | JGROUPS_ENCRYPT_NAME                         | jboss                                  |
       | JGROUPS_ENCRYPT_PASSWORD                     | mykeystorepass                         |
    Then container log should contain WFLYSRV0025:
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='encrypt-protocol'][@type='SYM_ENCRYPT']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/@key-store
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss on XPath //*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/@key-alias
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/*[local-name()="key-credential-reference"]/@clear-text
     # https://issues.jboss.org/browse/CLOUD-1192
     # https://issues.jboss.org/browse/CLOUD-1196
     # Make sure the SYM_ENCRYPT protocol is specified before pbcast.NAKACK for udp stack
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()="stack"][@name="udp"]/*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/following-sibling::*[1]/@type
     # Make sure the SYM_ENCRYPT protocol is specified before pbcast.NAKACK for tcp stack
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()="stack"][@name="tcp"]/*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/following-sibling::*[1]/@type

  Scenario: Check jgroups encryption with missing keystore dir creates the location relative to the server dir
    When container integ- is started with env
       | variable                                     | value                                  |
       | JGROUPS_ENCRYPT_PROTOCOL                     | SYM_ENCRYPT                            |
       | JGROUPS_ENCRYPT_SECRET                       | jdg_jgroups_encrypt_secret             |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                           |
       | JGROUPS_ENCRYPT_NAME                         | jboss                                  |
       | JGROUPS_ENCRYPT_PASSWORD                     | mykeystorepass                         |
    Then XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss.server.config.dir on XPath //*[local-name()="key-store"][@name="keystore.jks"]/*[local-name()="file"]/@relative-to

Scenario: Verify configuration and protocol positions jgroups-encrypt, DNS ping protocol and AUTH
    When container integ- is started with env
       | variable                                     | value                                  |
       | JGROUPS_ENCRYPT_SECRET                       | wildfly_jgroups_encrypt_secret             |
       | JGROUPS_ENCRYPT_KEYSTORE_DIR                 | /etc/jgroups-encrypt-secret-volume     |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                           |
       | JGROUPS_ENCRYPT_NAME                         | jboss                                  |
       | JGROUPS_ENCRYPT_PASSWORD                     | mykeystorepass                         |
       | JGROUPS_PING_PROTOCOL                        | dns.DNS_PING                           |
       | JGROUPS_CLUSTER_PASSWORD                     | P@assw0rd                              |
       |OPENSHIFT_DNS_PING_SERVICE_NAME    | foo |
    Then container log should contain WFLYSRV0025:
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='dns.DNS_PING']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='encrypt-protocol'][@type='SYM_ENCRYPT']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='auth-protocol'][@type='AUTH']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/@key-store
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss on XPath //*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/@key-alias
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/*[local-name()="key-credential-reference"]/@clear-text
     # https://issues.jboss.org/browse/CLOUD-1192
     # https://issues.jboss.org/browse/CLOUD-1196
     # Make sure the SYM_ENCRYPT protocol is specified before pbcast.NAKACK for udp stack
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()="stack"][@name="udp"]/*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/following-sibling::*[1]/@type
     # Make sure the SYM_ENCRYPT protocol is specified before pbcast.NAKACK for tcp stack
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()="stack"][@name="tcp"]/*[local-name()="encrypt-protocol"][@type="SYM_ENCRYPT"]/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()="stack"][@name="udp"]/*[local-name()="auth-protocol"][@type="AUTH"]/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()="stack"][@name="tcp"]/*[local-name()="auth-protocol"][@type="AUTH"]/following-sibling::*[1]/@type

Scenario: Verify configuration jgroups deprecated ASYM_ENCRYPT, kubernetes.KUBE_PING ping protocol and AUTH
    When container integ- is started with env
       | variable                                     | value                 |
       | JGROUPS_ENCRYPT_PROTOCOL                     | ASYM_ENCRYPT          |
       | JGROUPS_CLUSTER_PASSWORD                     | P@assw0rd             |
    Then container log should contain WFLYSRV0025:
     And container log should contain WARN Detected missing JGroups encryption configuration, the communication within the cluster will be encrypted using a deprecated version of ASYM_ENCRYPT protocol. You need to set all of these variables to configure ASYM_ENCRYPT using the Elytron keystore: JGROUPS_ENCRYPT_SECRET, JGROUPS_ENCRYPT_NAME, JGROUPS_ENCRYPT_PASSWORD, JGROUPS_ENCRYPT_KEYSTORE.
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='kubernetes.KUBE_PING']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='auth-protocol'][@type='AUTH']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 128 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value AES/ECB/PKCS5Padding on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 512 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value RSA on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='change_key_on_leave']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 128 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value AES/ECB/PKCS5Padding on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 512 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value RSA on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='change_key_on_leave']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/following-sibling::*[1]/@type

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type

Scenario: Verify configuration jgroups deprecated ASYM_ENCRYPT, dns.DNS_PING ping protocol and AUTH
    When container integ- is started with env
       | variable                                     | value                                  |
       | JGROUPS_ENCRYPT_PROTOCOL                     | ASYM_ENCRYPT                           |
       | JGROUPS_CLUSTER_PASSWORD                     | P@assw0rd                              |
       | JGROUPS_PING_PROTOCOL                        | dns.DNS_PING                           |
       |OPENSHIFT_DNS_PING_SERVICE_NAME    | foo |
    Then container log should contain WFLYSRV0025:
     And container log should contain WARN Detected missing JGroups encryption configuration, the communication within the cluster will be encrypted using a deprecated version of ASYM_ENCRYPT protocol. You need to set all of these variables to configure ASYM_ENCRYPT using the Elytron keystore: JGROUPS_ENCRYPT_SECRET, JGROUPS_ENCRYPT_NAME, JGROUPS_ENCRYPT_PASSWORD, JGROUPS_ENCRYPT_KEYSTORE.
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='dns.DNS_PING']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='auth-protocol'][@type='AUTH']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 128 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value AES/ECB/PKCS5Padding on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 512 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value RSA on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='change_key_on_leave']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 128 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value AES/ECB/PKCS5Padding on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='sym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value 512 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_keylength']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value RSA on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='asym_algorithm']
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value true on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/*[local-name()='property'][@name='change_key_on_leave']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='protocol'][@type='org.jgroups.protocols.ASYM_ENCRYPT']/following-sibling::*[1]/@type

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type

Scenario: Verify configuration jgroups non-deprecated ASYM_ENCRYPT, dns.DNS_PING ping and AUTH
    When container integ- is started with env
       | variable                                     | value                           |
       | JGROUPS_ENCRYPT_PROTOCOL                     | ASYM_ENCRYPT                    |
       | JGROUPS_ENCRYPT_SECRET                       | wildfly_jgroups_encrypt_secret      |
       | JGROUPS_ENCRYPT_PASSWORD                     | mykeystorepass                  |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                    |
       | JGROUPS_ENCRYPT_NAME                         | jboss                           |
       | JGROUPS_CLUSTER_PASSWORD                     | P@assw0rd                       |
       | JGROUPS_PING_PROTOCOL                        | dns.DNS_PING                    |
       | JGROUPS_ENCRYPT_KEYSTORE_DIR                 | /etc                            |
       |OPENSHIFT_DNS_PING_SERVICE_NAME    | foo |
    Then container log should contain WFLYSRV0025:
     And container log should contain INFO Detected valid JGroups encryption configuration, the communication within the cluster will be encrypted using ASYM_ENCRYPT and Elytron keystore.
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='dns.DNS_PING']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='auth-protocol'][@type='AUTH']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-alias
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-store
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/*[local-name()='key-credential-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-alias
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-store
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/*[local-name()='key-credential-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/following-sibling::*[1]/@type

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store']/@name
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name='keystore.jks']/*[local-name()='credential-reference']/@clear-text
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value /etc/keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name='keystore.jks']/*[local-name()='file']/@path
     And XML file /opt/server/standalone/configuration/standalone.xml should have 0 elements on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name='keystore.jks']/*[local-name()='file']/@relative-to

  Scenario: Verify configuration jgroups non-deprecated ASYM_ENCRYPT, kubernetes.KUBE_PING ping protocol ping and AUTH
    When container integ- is started with env
       | variable                                     | value                           |
       | JGROUPS_ENCRYPT_PROTOCOL                     | ASYM_ENCRYPT                    |
       | JGROUPS_ENCRYPT_SECRET                       | wildfly_jgroups_encrypt_secret      |
       | JGROUPS_ENCRYPT_PASSWORD                     | mykeystorepass                  |
       | JGROUPS_ENCRYPT_KEYSTORE                     | keystore.jks                    |
       | JGROUPS_ENCRYPT_NAME                         | jboss                           |
       | JGROUPS_CLUSTER_PASSWORD                     | P@assw0rd                       |
    Then container log should contain WFLYSRV0025:
     And container log should contain INFO Detected valid JGroups encryption configuration, the communication within the cluster will be encrypted using ASYM_ENCRYPT and Elytron keystore.
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='protocol'][@type='kubernetes.KUBE_PING']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']
     And XML file /opt/server/standalone/configuration/standalone.xml should have 2 elements on XPath //*[local-name()='auth-protocol'][@type='AUTH']

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value P@assw0rd on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']//*[local-name()='shared-secret-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-alias
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-store
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/*[local-name()='key-credential-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-alias
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/@key-store
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/*[local-name()='key-credential-reference']/@clear-text

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.NAKACK2 on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='encrypt-protocol'][@type='ASYM_ENCRYPT']/following-sibling::*[1]/@type

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='udp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value pbcast.GMS on XPath //*[local-name()='stack'][@name='tcp']/*[local-name()='auth-protocol'][@type='AUTH']/following-sibling::*[1]/@type

     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store']/@name
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value mykeystorepass on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name='keystore.jks']/*[local-name()='credential-reference']/@clear-text
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value keystore.jks on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name='keystore.jks']/*[local-name()='file']/@path
     And XML file /opt/server/standalone/configuration/standalone.xml should contain value jboss.server.config.dir on XPath //*[local-name()='tls']/*[local-name()='key-stores']/*[local-name()='key-store'][@name='keystore.jks']/*[local-name()='file']/@relative-to