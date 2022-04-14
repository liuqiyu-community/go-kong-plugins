FROM golang:1.16 as builder

RUN apk add --no-cache git gcc libc-dev
RUN go get github.com/Kong/go-pluginserver

RUN mkdir /go-plugins

# plugin hello
COPY ./go-plugins/hello/* /go-plugins/hello/
RUN go build -o /go-plugins/hello/hello /go-plugins/hello/hello.go

FROM kong:2.8.0

USER kong

COPY --from=builder /go-plugins/hello/hello /usr/local/bin/hello
