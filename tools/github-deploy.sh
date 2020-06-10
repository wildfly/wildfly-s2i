#!/bin/bash

# this is the path to the repo the build should run from. It should not begin with a leading /.
WILDFLY_REPO="${1:-wildfly/wildfly-s2i}"
WILDFLY_REF="${2:-master}"
WILDFLY_IMAGE_TAG="${3:-latest}"

if [ "${1}" == "--help" ]; then
 cat << EOF
   
   ${0} <github repo> <git ref> <tag to apply to image>
   ${0} wildfly/wildfly-s2i master latest

EOF
 exit
fi

if [ -z "${WILDFLYS2I_GITHUB_PAT}" ];
then
    echo
    echo "Using this script requires the creation of a personal access token here: https://github.com/settings/tokens"
    echo "The token should have the following permissions: repo:status, repo_deployment, public_repo, read:packages, read:discussion, workflow"
    echo "Then export the token in your current shell: export WILDFLYS2I_GITHUB_PAT=... and re-run this script. Your deployment action will run as the production deploy action in github actions."
    echo
else
  curl \
    -X POST \
    -H "Authorization: token $WILDFLYS2I_GITHUB_PAT" \
    -H "Accept: application/vnd.github.ant-man-preview+json" \
    -H "Content-Type: application/json" \
    https://api.github.com/repos/${WILDFLY_REPO}/deployments \
    --data "{\"ref\": \"${WILDFLY_REF}\", \"required_contexts\": [], \"environment\": \"production\", \"payload\": {\"image_tag\": \"${WILDFLY_IMAGE_TAG}\"}}"
fi
