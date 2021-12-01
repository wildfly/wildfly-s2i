#!/bin/bash
if [ -z "${WILDFLYS2I_GITHUB_PAT}" ];
then
    echo
    echo "Using this script requires the creation of a personal access token here: https://github.com/settings/tokens"
    echo "The token should have the following permissions: repo:status, repo_deployment, public_repo, read:packages, read:discussion, workflow"
    echo "Then export the token in your current shell: export WILDFLYS2I_GITHUB_PAT=... and re-run this script."
    echo
else
    curl \
    -X POST \
    -H "Authorization: token $WILDFLYS2I_GITHUB_PAT" \
    -H "Accept: application/vnd.github.ant-man-preview+json" \
    -H "Content-Type: application/json" \
    https://api.github.com/repos/jfdenise/wildfly-s2i/dispatches \
    --data '{"event_type": "test-master-wildfly"}'
fi
