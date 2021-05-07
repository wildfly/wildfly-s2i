Tools to help you build S2I images
=====================

build-s2i-image.sh
===========

* You want to create locally a wildfly-s2i image that depends on a local build of WildFly.
* You must have cekit and docker setup.

Usage: 

```
$ ./build-s2i-image.sh <path to wildfly built with -Drelease> --no-wildfly-build
```

build-app-image.sh
============

* You want to build locally an application image using s2i
* You must have cekit, s2i and docker setup.
* By default it uses `quay.io/wildfly/wildfly-centos7` and `quay.io/wildfly/wildfly-runtime-centos7` images. You can provide your own wildfly s2i builder and runtime images.
* If no application name is provided, the image name is derived from the application src directory.
* You can provide Galleon layers in order to build a trimmed-down server.

Usage:

```
$ ./build-app-image.sh <path to your app maven project> [--app-name=<application name>] [--galleon-layers=<comma separated list of layers>] [--wildfly-builder-image=<wildfly s2i builder image>] [--wildfly-runtime-image=<wildfly runtime image>]
```

github-wf-cekit-build.sh
==============

* Github action workflow.
* You have opened a PR against wildfly-cekit-modules and want to build/test/deploy to quay.io a wildfly-s2i image that depends on it
* You have possibly some changes in a wildfly-s2i branch.
* You don't have cekit, docker setup, or you don't want to build the image locally
* You must set ```WILDFLYS2I_GITHUB_PAT``` env variable to your GITHUB Personal Access Token.
* By default master branch of repositories in the wildfly organisation are used.
* To reference your own forks, branches use ```WILDFLYS2I_FORK_NAME```, ```WILDFLYS2I_BRANCH_NAME```, ```WILDFLYCEKIT_FORK_NAME``` and ```WILDFLYCEKIT_BRANCH_NAME```
* If you want the images to be pushed to your quay.io account (that must contain wildfly-centos7 and wildfly-runtime-centos7 repositories), you must set the following secrets: ```QUAY_REPO, QUAY_USERNAME, QUAY_PASSWORD```
* The pushed image version is:```wf-cekit-<wildfly-cekit-module branch>```

Usage:

```
$ ./github-wf-cekit-build.sh
```
