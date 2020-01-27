#!/bin/bash

SCRIPT_DIR=$(dirname $0)
ADDED_DIR=${SCRIPT_DIR}/added
SOURCES_DIR="/tmp/artifacts"

unzip -o $SOURCES_DIR/keycloak-wildfly-adapter-dist-8.0.0.zip -d $JBOSS_HOME
unzip -o $SOURCES_DIR/keycloak-saml-wildfly-adapter-dist-8.0.0.zip -d $JBOSS_HOME

chown -R jboss:root $JBOSS_HOME
chmod -R g+rwX $JBOSS_HOME