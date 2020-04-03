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

FROM alpine:latest AS base

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

######
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN mkdir -p /api
WORKDIR /api

# DEV
FROM builder as dev
#FROM base as dev
RUN apk add --no-cache autoconf automake libtool gettext gettext-dev make g++ texinfo curl
# fswatch is not available at alpine packages
WORKDIR /root
RUN wget https://github.com/emcrisostomo/fswatch/releases/download/1.14.0/fswatch-1.14.0.tar.gz
RUN tar -xvzf fswatch-1.14.0.tar.gz
WORKDIR /root/fswatch-1.14.0
RUN ./configure
RUN make
RUN make install

########

RUN mkdir -p /api
WORKDIR /api
COPY --from=builder /api/app .
COPY --from=builder /api/test.db .
ADD src/views ./views

###you will need to uncomment this 2 lines if you want to use run.sh
#EXPOSE 8080

#ENTRYPOINT ["./app"]
