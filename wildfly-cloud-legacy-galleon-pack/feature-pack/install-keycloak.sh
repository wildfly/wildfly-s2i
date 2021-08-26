#!/bin/bash
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

if [[ "$OSTYPE" == "darwin"* ]]; then
  # OS X - has a different find syntax
  find . -name module.xml -print0 | xargs -0 stat -f '%N' | xargs -0 > "$target_file"
  # Remove leading './' which happen with OS X's find
  sed -i "" -e "s|./||" "$target_file"
  # Remove any empty lines
  grep '[^[:blank:]]' < "$target_file" > "$target_file.bak"
  mv "$target_file.bak" "$target_file"
else
  # Standard Linux bash sed syntax
  find . -name module.xml -printf '%P\n' > "$target_file"
fi
while read line; do
  parentdir="$(dirname $line)"
  parentdir="$(dirname $parentdir)"
  modulename=${parentdir//\//.}
  pkgs="$pkgs<package name=\"$modulename\"/>\n"
done < "$target_file"
rm "$target_file"
popd

# Replace the placeholders in keycloak.xml with $pkgs
if [[ "$OSTYPE" == "darwin"* ]]; then
  # OS X - has a different sed syntax
  sed -i "" -e "s|<!-- ##KEYCLOAK_PACKAGES## -->|$pkgs|" "$resources_dir/feature_groups/keycloak.xml"
else
  # Standard Linux bash sed syntax
  sed -i "s|<!-- ##KEYCLOAK_PACKAGES## -->|$pkgs|" "$resources_dir/feature_groups/keycloak.xml"
fi
