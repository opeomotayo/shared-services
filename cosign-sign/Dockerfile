FROM golang:1.15 as builder
COPY . /usr/local
WORKDIR /usr/local/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /bin/app
ENTRYPOINT ["/bin/app"]
