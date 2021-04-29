Simple example to highlight usage of jsf, ejb-lite and jpa Galleon layers. 

Setup openshift
===============

* Import builder image:
```
oc import-image wildfly --from=quay.io/wildfly/wildfly-centos7:latest --confirm
```
* Import runtime image: 
```
oc import-image wildfly-runtime --from=quay.io/wildfly/wildfly-runtime-centos7:latest --confirm
```
* Chained build template: 
```
oc create -f templates/wildfly-s2i-chained-build-template.yml
```

Build and run the application
=============================

We are provisioning a server with support for JSF, EJB and JPA.

* Build application image: 
```
oc new-app wildfly-s2i-chained-build-template -p APPLICATION_NAME=jsf-ejb-jpa \
      -p GIT_REPO=https://github.com/wildfly/wildfly-s2i \
      -p GIT_CONTEXT_DIR=examples/jsf-ejb-jpa \
      -p GALLEON_PROVISION_LAYERS=web-server,ejb-lite,jsf,jpa,h2-driver,observability \
      -p IMAGE_STREAM_NAMESPACE=myproject
```

* Create application from application image: 
```
oc new-app myproject/jsf-ejb-jpa
```

* Create a route:
```
oc expose svc/jsf-ejb-jpa
```

* Access the application route.

You will see pre-populated tasks. You can add / delete tasks. 