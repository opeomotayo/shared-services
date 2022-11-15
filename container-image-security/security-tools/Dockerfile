FROM alpine:latest

LABEL maintainer="Shaun Jackman <sjackman@gmail.com>"
LABEL name="linuxbrew/alpine"

RUN apk update \
	&& apk --no-cache add bash coreutils curl file g++ grep git libc6-compat make ruby ruby-bigdecimal ruby-etc ruby-irb ruby-json ruby-test-unit sudo \
	&& adduser -D -s /bin/bash linuxbrew \
	&& echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
	&& ln -s /bin/touch /usr/bin/touch
RUN apk add --no-cache bash

USER linuxbrew
WORKDIR /home/linuxbrew
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash \
	USER=linuxbrew

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
	&& HOMEBREW_NO_ANALYTICS=1 brew install -s patchelf \
	&& HOMEBREW_NO_ANALYTICS=1 brew install --ignore-dependencies binutils gmp isl@0.18 libmpc linux-headers mpfr zlib \
	&& (HOMEBREW_NO_ANALYTICS=1 brew install --ignore-dependencies gcc || true) \
	&& HOMEBREW_NO_ANALYTICS=1 brew install glibc \
	&& HOMEBREW_NO_ANALYTICS=1 brew postinstall gcc \
	&& HOMEBREW_NO_ANALYTICS=1 brew remove patchelf \
	&& HOMEBREW_NO_ANALYTICS=1 brew install -s patchelf \
	&& HOMEBREW_NO_ANALYTICS=1 brew config

#docker
RUN apk add --update docker openrc
RUN rc-update add docker boot

#cosign
RUN wget "https://github.com/sigstore/cosign/releases/download/v1.6.0/cosign-linux-amd64"
RUN  mv cosign-linux-amd64 /usr/local/bin/cosign
RUN chmod +x /usr/local/bin/cosign

#syft
RUN apk add curl
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

#jq
RUN apk add jq

#grype
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

#aqua
RUN curl -O https://get.aquasec.com/aquactl/v3/aquactl && chmod +x ./aquactl

CMD ["/bin/bash"]