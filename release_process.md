
[DEPRECATED], just used for maintaining WF 26 images.

Release Process
==========


Pre-requisites

* A new wildfly-datasources-galleon-pack has been released that depends on latest WildFly.
* wildfly-cekit-modules has been tagged.
* If some changes occured in cct_modules, make sure that a tag exists.
* A new wildfly-cloud-legacy-galleon-pack has been released that depends on latest WildFly.

Quay.io secrets [REQUIRED]

* QUAY_REPO: quay organization
* QUAY_USERNAME: user that pushes images to quay.io
* QUAY_PASSWORD: user's password

Openshift secrets [OPTIONAL]

Once the images have been pushed to quay.io, if you have setup the following secrets, deployment 
of the microprofile-config quickstart is operated on Openshift using helm charts.

* OPENSHIFT_SERVER: cluster url
* OPENSHIFT_TOKEN: cluster connection token


Release a respin (minor/micro of WildFly changed)
===============================

* Make changes in wf-XX.0 own fork branch
  * Upgrade to latest WildFly, cloud datasources FP, ...
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