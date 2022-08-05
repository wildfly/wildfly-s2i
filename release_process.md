# Release Process

## SNAPSHOT images

The versions of the builder and runtime images are of the form: `1.x.x-snapshot`.

When a change that impacts the images is pushed in [wildfly-s2i](https://github.com/wildfly/wildfly-s2i) or 
[wildfly-cekit-modules](https://github.com/wildfly/wildfly-cekit-modules) repositories main branches,  
new snapshot images are deployed to the `quay.io/wildfly-snapshots` organization.

## Releasing new images

### Release new images

* Tag [wildfly-cekit-modules](https://github.com/wildfly/wildfly-cekit-modules) if needed.
* Ask for a tag in [openjdk s2i image](https://github.com/jboss-container-images/openjdk) modules repo if needed.
* In the wildfly-s2i main branch, update the [builder](wildfly-builder-image/image.yaml) and [runtime](wildfly-runtime-image/image.yaml) 
image versions from `1.x.x-snapshot` to `1.x.x` and use the new `wildfly-cekit-modules` and `openjdk` tags as `ref`.
* Open PR, tests are green, merge PR in main.
* CI job on push build and deploy the images in `quay.io`, detects that the version is not a `snapshot`, deploy images in `quay.io/wildfly` organization 
and creates “latest” image tags.
* Tag wildfly-s2i  branch (eg: `1.0.0`), push tag.

### Switch back to snapshot

* In the wildfly-s2i main branch, update the [builder](wildfly-builder-image/image.yaml) and [runtime](wildfly-runtime-image/image.yaml)  
image versions to `1.x.(x+1)-snapshot` and use `main` ref for wildfly-cekit-modules and `develop` ref for openjdk.
* Open PR. Merge. New snapshot images will be built and pushed in `quay.io/wildfly-snapshots` organisation.

## Respin existing images

To respin an image pushed to Quay.io,

* Identify the image tag from https://github.com/wildfly/wildfly-s2i/tags
* Go to the commit corresponding to the tag (e.g. https://github.com/wildfly/wildfly-s2i/commit/5538bdb033bff3375d1d89ae6e24a669a9cc6951 for the `1.1.2` tag)
* On the left of the commit message, there is a green check that links the GitHub actions triggered by this commit.
  * Click on `Details` to go to the corresponding GitHub action run
  * Click on `Re-run all jobs`