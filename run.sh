#!/usr/bin/env bash
##remember to uncomment the last 2 lines
# of the Dockerfile if you want to use this script
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker build . -t go-gin
docker run -i -t -p 8080:8080 go-gin
