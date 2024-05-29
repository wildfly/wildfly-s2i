This project defines Images allowing you to build and deploy WildFly applications on the cloud.

Documentation for WildFly S2I (Source to Image) and runtime images can be found [there](https://docs.wildfly.org/wildfly-s2i/).

# Relationship with WildFly s2i centos7 images

These new images replace the `quay.io/wildfly/wildfly-centos7` and `quay.io/wildfy/wildfly-runtime-centos7` images.

As opposed to the `wildfly-centos7` WildFly s2i builder image that is containing a WildFly server, the new builder image 
is a generic builder allowing to build image for any WildFly releases.

Releasing new images is no more bound to WildFly server releases. Releases are done for fixes and new features done in the image.

# Building the images

You must have [cekit](https://github.com/cekit/cekit) installed.

## Building the JDK11 images

* `cd wildfly-builder-image; cekit build --overrides=jdk11-overrides.yaml docker`
* `cd wildfly-runtime-image; cekit build --overrides=jdk11-overrides.yaml docker`

## Building the JDK17 images

* `cd wildfly-builder-image; cekit build --overrides=jdk17-overrides.yaml docker`
* `cd wildfly-runtime-image; cekit build --overrides=jdk17-overrides.yaml docker`

## Building the JDK21 images

* `cd wildfly-builder-image; cekit build --overrides=jdk21-overrides.yaml docker`
* `cd wildfly-runtime-image; cekit build --overrides=jdk21-overrides.yaml docker`

## Tests executed for new Pull request

###  Steps

Behave tests are run when a PR is opened against the wildfly-s2i repository.
The github action workflow [file](https://github.com/wildfly/wildfly-s2i/blob/main/.github/workflows/main.yml) is run.
The steps are as follow:
* Build multiarch images for all supported JDK.
* Then, for each behave feature [files](https://github.com/wildfly/wildfly-s2i/tree/main/wildfly-builder-image/tests/features):
* Execute the test, and redirect logs to `<feature name>-ubuntu-latest-${{ matrix.jdk }}.txt`
* call `docker system prune` to release unreferenced images.
* If a failure occurs, the workflow is aborted and the logs are collected.

NOTE: Some tests are not supported on JDK11 (for example, starting WildFly 32, WildFly preview requires JDK17 as its minimal JDK version). Such tests 
are not executed on JDK11 and are all located in the feature file: `no-jdk11.feature`

### Understanding the failure logs

The features test execution has been split into multiple executions due to created images resource consumption and log size.
Each feature file has its own execution with its own log.
When a failure occurs:
* Check the Github action execution log. Note the feature file name that failed.
* Download the log files.
* Unzip the log files and search for the `wildfly-s2i-test-logs-ubuntu-latest-<jdk>/**/test-logs-legacy-s2i-ubuntu-latest-jdk11.txt<feature name>-ubuntu-latest-<jdk>.txt` file.
* Access the end of the file: `tail -f --lines 100 <path of the file>`
* You should see something like:
```
Failing scenarios:
  features/image/no-jdk11-legacy-s2i.feature:4  Test preview FP and preview cloud FP with legacy app.

1 feature passed, 1 failed, 0 skipped
9 scenarios passed, 1 failed, 0 skipped
38 steps passed, 1 failed, 3 skipped, 0 undefined
Took 8m17.543s
```
You can then grep the feature name inside the file, for example (`Test preview FP and preview cloud FP with legacy app.`) and look at the failure.

NOTE: The S2I build logs contain ERROR traces that are not actual errors, just traces. For example: 

`ERROR I0426 14:07:03.322859  349849 build.go:51] Running S2I version "v1.3.1"`

You can ignore such traces. Search for `Traceback`, that is the stack trace of the failure. 
