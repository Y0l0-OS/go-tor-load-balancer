FROM golang:alpine AS builder
RUN apk add git && mkdir /src/ && git clone https://github.com/extremecoders-re/go-dispatch-proxy.git /src/proxy 
RUN cd /src/proxy && go build 

FROM docker.io/library/alpine:latest
COPY --from=0  /src/proxy/go-dispatch-proxy /usr/bin
#run /usr/bin/go-dispatch-proxy --help && sleep 5 
RUN apk add tor screen curl 
COPY bootstrap.sh newip.sh /
ENTRYPOINT ash /bootstrap.sh
EXPOSE 9050
