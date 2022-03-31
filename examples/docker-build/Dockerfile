ARG runtime_image=quay.io/jfdenise/wildfly-runtime-jdk11:latest
FROM ${runtime_image}
COPY --chown=jboss:root target/server $JBOSS_HOME
RUN chmod -R ug+rwX $JBOSS_HOME
