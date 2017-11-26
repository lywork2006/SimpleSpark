#!/bin/bash

docker stop spark220
docker rm spark220
docker build -t spark220 .

sh run.sh
