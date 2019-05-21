#!/bin/sh
# Configure module
set -e

# Download offliner runtime
curl -v -L http://repo.maven.apache.org/maven2/com/redhat/red/offliner/offliner/1.6/offliner-1.6.jar > /tmp/offliner.jar

# Download offliner file
curl -v -L https://repository.jboss.org/nexus/content/groups/public/org/wildfly/wildfly-dist/${WILDFLY_VERSION}/wildfly-dist-${WILDFLY_VERSION}-artifact-list.txt > /tmp/offliner.txt

# Populate maven repo
java -jar /tmp/offliner.jar --url https://repo1.maven.org/maven2/ --url https://repository.jboss.org/nexus/content/groups/public/ \
/tmp/offliner.txt --dir $MAVEN_LOCAL_REPO > /dev/null

rm /tmp/offliner.jar && rm /tmp/offliner.txt

# required to have maven enabled.
source $JBOSS_CONTAINER_MAVEN_35_MODULE/scl-enable-maven

# Copy JBOSS_HOME content (custom os content) to common package dir
mkdir -p $JBOSS_CONTAINER_WILDFLY_GALLEON_FP_PACKAGES/wildfly.s2i.common/content
cp -r $JBOSS_HOME/* $JBOSS_CONTAINER_WILDFLY_GALLEON_FP_PACKAGES/wildfly.s2i.common/content
rm -rf $JBOSS_HOME/*

# Build WildFly s2i feature-pack and install it in local maven repository
# The active profiles are jboss-community-repository and securecentral
mvn -f $JBOSS_CONTAINER_WILDFLY_GALLEON_MODULE/wildfly-s2i-galleon-pack/pom.xml install \
-Dcom.redhat.xpaas.repo.jbossorg --settings $HOME/.m2/settings.xml -Dmaven.repo.local=$MAVEN_LOCAL_REPO

# Remove the feature-pack src
rm -rf $JBOSS_CONTAINER_WILDFLY_GALLEON_MODULE/wildfly-s2i-galleon-pack
