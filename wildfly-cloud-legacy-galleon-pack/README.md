# wildfly-cloud-legacy-galleon-pack

This WildFly Galleon feature-pack captures the changes that are applied to a WildFly server inside the WildFly s2i image.

For now it is used internally by the WildFly s2i image.

# Release the galleon feature-pack

* In the pom.xml file:
 * Update the dependency on WildFly galleon-pack to the latest WildFly release.
 * Update the project version to the same WildFly version it depends on.
 * Reference the cct_module and wildfly-cekit-modules versions in use. Set CCT_MODULES_TAG, WILDFLY_CEKIT_TAG env variable in the ant plugin.
 * Reference the keycloak version in use. Set KEYCLOAK_VERSION env variable in the ant plugin.
