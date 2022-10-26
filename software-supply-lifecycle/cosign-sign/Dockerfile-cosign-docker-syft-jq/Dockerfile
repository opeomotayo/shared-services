FROM alpine

RUN apk update 

RUN apk add --update docker openrc
RUN rc-update add docker boot
  
RUN wget "https://github.com/sigstore/cosign/releases/download/v1.6.0/cosign-linux-amd64"
RUN  mv cosign-linux-amd64 /usr/local/bin/cosign
RUN chmod +x /usr/local/bin/cosign

RUN apk add curl
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

RUN apk add jq
