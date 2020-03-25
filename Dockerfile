ARG GO_VERSION=1.11

FROM golang:${GO_VERSION}-alpine AS builder

RUN apk update && apk add alpine-sdk git && rm -rf /var/cache/apk/*

RUN mkdir -p /api
WORKDIR /api

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go get -u github.com/gin-gonic/gin
RUN go get -u github.com/gin-gonic/contrib/static
#RUN go get -u github.com/chunghha/docker-go-gin
#RUN go get -u github.com/auth0/go-jwt-middleware
#RUN go get -u github.com/dgrijalva/jwt-go
#env for auth
#ADD src/.env ./.env
#RUN source .env
RUN go build -o ./app ./src/main.go

FROM alpine:latest

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

RUN mkdir -p /api
WORKDIR /api
COPY --from=builder /api/app .
COPY --from=builder /api/test.db .
ADD src/views ./views

EXPOSE 8080

ENTRYPOINT ["./app"]
