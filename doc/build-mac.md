Building on Mac
===============

* Installing Docker
 * Install [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-mac)

* Installing Python (required by cekit)
 * Install [python 3](https://www.python.org)
 * Install virtualenv: `sudo pip3 install virtualenv`
 * Create a directory for the cekit virtualenv: `mkdir my-vertualenv`
 * Create the virtualenv: `virtualenv my-vertualenv/cekit`
 * Activate the virtualenv `source my-vertualenv/cekit/bin/activate`

* Installing cekit and dependencies. NB: Be sure to install a cekit version >= to 3.1.0.
  * `pip3 install cekit`
  * `pip3 install docker`
  * `pip3 install docker_squash`

You are ready to build WildFly images using cekit!

Known issues
============

On Mac, if you are using cekit 3.0.1, you will be impacted by this [issue](https://github.com/cekit/cekit/issues/517).
To workaround this problem, you need to do the build in 2 steps.
run cekit first, it will fail but the target/image/Dockerfile is properly generated so you can then use docker to build the image.
For example, to build the builder image:

```
$ cd wildfly-builder-image
$ cekit build docker
$ cd target/image
$ docker build -t wildfly/wildfly-builder:latest .
```