FROM alpine
RUN apk add --update docker openrc
RUN rc-update add docker boot
  
RUN wget "https://github.com/sigstore/cosign/releases/download/v1.6.0/cosign-linux-amd64"
RUN  mv cosign-linux-amd64 /usr/local/bin/cosign
RUN chmod +x /usr/local/bin/cosign
