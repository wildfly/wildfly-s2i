#!/bin/sh

function configure() {
 local configureMode
 getConfigurationMode "" "configureMode"
 if [ "${configureMode}" = "cli" ]; then
  configureByCli
 fi
}

function configureByCli() {
 if [ -n "$POSTGRESQL_DATABASE" ]
 then
  cat <<'EOF' >> ${CLI_SCRIPT_FILE}
      if (outcome == success) of /subsystem=datasources/data-source=PostgreSQLDS:read-resource
        /subsystem=datasources/data-source=PostgreSQLDS:write-attribute(name=enabled,value=true)
      end-if
EOF
 fi
}