FROM golang:1.21-alpine3.18 AS build

LABEL org.opencontainers.image.source="https://github.com/writefreely/writefreely"
LABEL org.opencontainers.image.description="WriteFreely is a clean, minimalist publishing platform made for writers. Start a blog, share knowledge within your organization, or build a community around the shared act of writing."

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    GO111MODULE="on" \
    NODE_OPTIONS="--openssl-legacy-provider"

WORKDIR /go/src/github.com/writefreely/writefreely

RUN \
    apk update --no-cache && \
    apk -U upgrade && \
    apk add --no-cache nodejs npm make g++ git curl && \
    npm install -g less less-plugin-clean-css && \
    curl -fsSL "https://github.com/writefreely/writefreely/archive/refs/tags/v${VERSION}.tar.gz" \
    | tar xzf - -C /go/src/github.com/writefreely/writefreely --strip-components=1 && \
    cat ossl_legacy.cnf >> /etc/ssl/openssl.cnf && \
    make build && \
    make ui && \
    mkdir /stage && \
    cp -R /go/bin \
    /go/src/github.com/writefreely/writefreely/templates \
    /go/src/github.com/writefreely/writefreely/static \
    /go/src/github.com/writefreely/writefreely/pages \
    /go/src/github.com/writefreely/writefreely/keys \
    /go/src/github.com/writefreely/writefreely/cmd \
    /stage && \
    rm -rf /tmp


FROM alpine:3.21.0

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache openssl ca-certificates catatonit bash

COPY --from=build --chown=daemon:daemon /stage /go
COPY ./apps/writefreely/entrypoint.sh /entrypoint.sh

WORKDIR /go
VOLUME /go/keys
EXPOSE 8080
USER daemon

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

HEALTHCHECK --start-period=5s --interval=15s --timeout=5s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1
