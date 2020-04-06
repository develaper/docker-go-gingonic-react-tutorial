```
docker build . -t go-gin
docker run -i -t -p 8080:8080 go-gin
```

*Or if you can run bash then just,*

```
sh run.sh
```

LIVE RELOAD WITH DOCKER-COMPOSE
  Based on: https://github.com/spalt08/go-live-reload
  How to run it:
```
docker-compose up --build development
```
