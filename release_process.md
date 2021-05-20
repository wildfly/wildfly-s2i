
Release Process
==========

Quay.io secrets [REQUIRED]

* QUAY_REPO: quay organization
* QUAY_USERNAME: user that pushes images to quay.io
* QUAY_PASSWORD: user's password

Openshift secrets [OPTIONAL]

Once the images have been pushed to quay.io, if you have setup the following secrets, deployment 
of the microprofile-config quickstart is operated on Openshift using helm charts.

* OPENSHIFT_SERVER: cluster url
* OPENSHIFT_TOKEN: cluster connection token

Steps

TBD
