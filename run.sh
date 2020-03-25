#!/usr/bin/env bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker build . -t go-gin
docker run -i -t -p 8080:8080 go-gin
