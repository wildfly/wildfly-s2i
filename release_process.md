
Release Process
==========


Pre-requisites

* A new wildfly-datasources-galleon-pack has been released that depends on latest WildFly.
* wildfly-cekit-modules has been tagged.
* If some changes occured in cct_modules, make sure that a tag exists.

Quay.io secrets [REQUIRED]

* QUAY_REPO: quay organization
* QUAY_USERNAME: user that pushes images to quay.io
* QUAY_PASSWORD: user's password

Openshift secrets [OPTIONAL]

Once the images have been pushed to quay.io, if you have setup the following secrets, deployment 
of the microprofile-config quickstart is operated on Openshift using helm charts.

* OPENSHIFT_SERVER: cluster url
* OPENSHIFT_TOKEN: cluster connection token


A New Major WildFly version has been released
============================

Steps

* Make changes in master branch:
  * [Latest wildfly version](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-modules/jboss/container/wildfly/base/module.yaml#L8)
  * [Datasources version](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-modules/jboss/container/wildfly/galleon-wildfly/module.yaml#L10)
  * [s2i FP version](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-modules/jboss/container/wildfly/galleon-wildfly/module.yaml#L8)
  * [s2i FP pom file version](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-modules/jboss/container/wildfly/galleon-wildfly/artifacts/opt/jboss/container/wildfly/galleon/wildfly-s2i-galleon-pack/pom.xml#L23)
  * Add new image stream for [builder](https://github.com/wildfly/wildfly-s2i/blob/master/imagestreams/wildfly-centos7.json) and [runtime](https://github.com/wildfly/wildfly-s2i/blob/master/imagestreams/wildfly-runtime-centos7.json) images.  
  * Update image tags in [builder](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-builder-image/image.yaml#L15) and [runtime](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-runtime-image/image.yaml#L11) image
* Open PR, if green, merge.
* Create a wf-XX.0 branch in upstream.
* Make changes in own fork:
  * Update [builder](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-builder-image/image.yaml) and [runtime](https://github.com/wildfly/wildfly-s2i/blob/master/wildfly-runtime-image/image.yaml) yml files with image version (eg: 23.0), update wildfly-cekit-modules  and cct_modules tags.
  * Update version in [makefile](https://github.com/wildfly/wildfly-s2i/blob/master/Makefile#L1) (used by test).
* Open PR, expect green results. 
  * Re-run if needed, analyze random errors if any. We have some tests that fails randomly due to cekit, remote maven repo, ..
* Create and push a vXX.0 tag in fork.
  * Github action is fired and build/push images in the staging area. TESTS are NOT RUN again.
  * 2 tags are pushed for each image, the actual version image (eg: 23.0.2) and latest
  * NB: QUAY_XXX secrets reference the one in the fork.
  * If you enabled Openshift deployment, be sure to monitor that the build/deployment worked properly (can take some time...)
* Advertise to third-parties that images are available in the staging area.
  * Images are good. Merge PR in wf-XX.0
* Create and push a vXX.0 tag in upstream.
  * Github action is fired and build/push images in the production area. TESTS are NOT RUN again.
  * 2 tags are pushed for each image, the actual version image (eg: 23.0.2) and latest
  * NB: QUAY_XXX secrets reference the one in the upstream repository.
  * If you enabled Openshift deployment, be sure to monitor that the build/deployment worked properly (can take some time...)
* The ‘current’ branch (that is monitored by Openshift Library) must be updated with the tag.
* DONE

Release a respin (minor/micro of WildFly changed)
===============================

* Make changes in wf-XX.0 own fork branch
  * Upgrade to latest WildFly, datasources FP, ...
  * Update builder and runtime yml files with image version (eg: 23.0.1)
  * Update version in makefile (used by test).
* Open PR, expect green results. 
  * Re-run if needed, analyze random errors if any
* Create and push a vXX.0.x tag in fork. Tag name is important, action started only when tag name starts with a ‘v’.
  * Github action is fired and build/push images in the staging area. TESTS are NOT RUN again.
  * 2 tags are pushed for each image, the actual version image (eg: 23.0.2) and latest
  * NB: QUAY_XXX secrets reference the one in the fork.
  * If you enabled Openshift deployment, be sure to monitor that the build/deployment worked properly (can take some time...)
* Advertise to third-parties that images are available.
  * Images are good. Merge PR in wf-XX.0
* Create and push a vXX.0 tag in upstream.
  * Github action is fired and build/push images in the production area. TESTS are NOT RUN again.
  * 2 tags are pushed for each image, the actual version image (eg: 23.0.2) and latest
  * NB: QUAY_XXX secrets reference the one in the upstream repository.
  * If you enabled Openshift deployment, be sure to monitor that the build/deployment worked properly (can take some time...)
* Manual tagging is then required:
  * Tag current minor image to a micro (eg: 23.0 => 23.0.0)
  * Tag new image to current minor image (eg: 23.0.2 ⇒ 23.0)
* DONE