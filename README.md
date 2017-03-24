# Owncloud Spring Cloud Example
The goal of this Project is to show the Combination of
* Spring Cloud Config Server
* Spring Cloud Eureka Service Registry
* Spring Cloud Feign (included Hystrix and Ribbon)
* Spring Cloud Turbine
* Spring Cloud Hystrix Dashboard
* Docker
* Docker Compose

# Installation
Run ``mvn -P withDocker clean install``. After a successful Build the following
Docker Images have been created
| Docker Image                                 | Description                         |
| -------------------------------------------- | ----------------------------------- |
| mufasa1976/spring-cloud-example-configserver | Configuration Server                |
| mufasa1976/spring-cloud-example-eureka       | Eureka Service Discovery            |
| mufasa1976/spring-cloud-example-service      | internal Service                    |
| mufasa1976/spring-cloud-example-turbine      | User Endpoint and Hystrix Dashboard |
After this you can start the whole Application by ``./docker-compose.sh``. \
This little Shell-Scripts starts all neccessary Containers in the correct
Order and waits until the Application is up and running.

# Try it out
Start the Application with a simple Shell-Script ``./docker-compose.sh``. \
This Shell-Script starts all neccessary Containers in the correct Order.

The Application has a simple REST-Endpoint ``GET localhost:8080/hint`` which
will print the Text ``There is a Hint``.

```bash
$> curl localhost:8080/hint
There is a Hint
```
Maybe the first Time there will be an Error (Timeout with no fallback).
But the second Time you try the Feign-Proxy has been successfully created
and you will see the expected Result.

Shut down the Application with ``docker-compose down``.

# Monitor
The Hystrix Metrics will be aggregated by Turbine. This aggregated Stream
will be available right after the Feign-Proxy has been created.

The Hystrix-Dashboard is available under ``http://localhost:8080/hystrix``. \
The Stream-URL then is ``http://turbine:8080/turbine.stream``

Eureka is available by ``http://localhost:8761``.
