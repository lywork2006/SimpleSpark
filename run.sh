#!/bin/bash

docker run -it -p 4040:4040 -p 8080:8080 -p 8081:8081 -p 8787:8787 -p 8888:8888 -h spark --name=spark220 spark220
docker exec -it spark220 service tomcat8 start
