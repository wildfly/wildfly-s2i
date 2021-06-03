#!/bin/sh
#install keycloak oidc and saml adapters, generated feature-group to reference thekeycloak  JBoss modules modules.
SCRIPT_DIR=$(dirname $0)
wget -c https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-oidc-wildfly-adapter-${KEYCLOAK_VERSION}.zip -O keycloak-oidc-wildfly-adapter.zip
wget -c https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-saml-wildfly-adapter-${KEYCLOAK_VERSION}.zip -O keycloak-saml-wildfly-adapter.zip
tmp_dir="$SCRIPT_DIR/target/tmp"
resources_dir="$SCRIPT_DIR/target/resources"
modules_dir="$resources_dir/modules"
keycloak_package_dir="$resources_dir/packages/wildfly.s2i.keycloak"

mkdir -p $modules_dir
mkdir -p $tmp_dir
echo TMP DIR $tmp_dir
unzip -o keycloak-oidc-wildfly-adapter.zip -d $tmp_dir
unzip -o keycloak-saml-wildfly-adapter.zip -d $tmp_dir
cp -r $tmp_dir/modules/* "$modules_dir"
rm keycloak-oidc-wildfly-adapter.zip
rm keycloak-saml-wildfly-adapter.zip
# Generate the set of keycloak packages.
pushd "$modules_dir/system/add-ons/keycloak/"
target_file="/tmp/keycloak_modules.txt"
find -name module.xml -printf '%P\n' > "$target_file"
while read line; do
  parentdir="$(dirname $line)"
  parentdir="$(dirname $parentdir)"
  modulename=${parentdir//\//.}
  pkgs="$pkgs<package name=\"$modulename\"/>\n"
done < "$target_file"
rm "$target_file"
popd

sed -i "s|<!-- ##KEYCLOAK_PACKAGES## -->|$pkgs|" "$resources_dir/feature_groups/keycloak.xml"

