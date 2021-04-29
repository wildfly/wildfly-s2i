#!/bin/bash

if [ -z "${WILDFLYS2I_FORK_NAME}" ];
then
  WILDFLYS2I_FORK_NAME="wildfly"
fi

echo "Using wildfly-s2i repo http://github.com/${WILDFLYS2I_FORK_NAME}/wildfly-s2i"

if [ -z "${WILDFLYS2I_BRANCH_NAME}" ];
then
  WILDFLYS2I_BRANCH_NAME="master"
fi

echo "Using wildfly-s2i ${WILDFLYS2I_BRANCH_NAME} branch"

if [ -z "${WILDFLYCEKIT_FORK_NAME}" ];
then
  WILDFLYCEKIT_FORK_NAME="wildfly"
fi

echo "Using wildfly-cekit-modules repo http://github.com/${WILDFLYCEKIT_FORK_NAME}/wildfly-cekit-modules"

if [ -z "${WILDFLYCEKIT_BRANCH_NAME}" ];
then
  WILDFLYCEKIT_BRANCH_NAME="master"
fi

echo "Using wildfly-cekit-modules '${WILDFLYCEKIT_BRANCH_NAME}' branch"

# this is the path to the repo the build should run from. It should not begin with a leading /.
WILDFLY_REPO="${WILDFLYS2I_FORK_NAME}/wildfly-s2i/dispatches"

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
    https://api.github.com/repos/${WILDFLY_REPO} \
    --data '{"event_type": "custom-wf-cekit-build", "client_payload": { "wf-s2i-ref": "'"${WILDFLYS2I_BRANCH_NAME}"'", "wf-cekit-fork": "'"$WILDFLYCEKIT_FORK_NAME"'", "wf-cekit-ref": "'"$WILDFLYCEKIT_BRANCH_NAME"'"  } }'
fi
