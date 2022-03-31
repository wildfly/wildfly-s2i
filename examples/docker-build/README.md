# Building a WildFly server docker image

In this example we are making use of the WildFly runtime image to build a WildFly server docker image for our application (simple JAX_RS endpoint).
In order to create a WildFly server containing our application, we are using the [WildFly Maven Plugin](https://github.com/wildfly/wildfly-maven-plugin/).

# WildFly Maven plugin configuration
High level view of the WildFly Maven plugin configuration

## Galleon feature-packs

* `wildfly@maven(org.jboss.universe:community-universe)`: Resolve the latest released WildFly server.

## Galleon layers

* `jaxrs-server`

## CLI scripts
WildFly CLI scripts executed at packaging time

* None

## Extra content
Extra content packaged inside the provisioned server

* None

# Example steps

1. Build the application  and server

```
mvn clean package
```

2. Build the docker image

```
docker build -t myapp:latest .
```

3. Run the image

```
docker run myapp:latest
```

4. Access the endpoint

```
curl http://<docker image IP>:8080/
```

5. Stop the server

In the console type `Ctrl-C`.
