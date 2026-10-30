FROM docker.io/library/alpine:3.20 AS source

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN \
    apk add --no-cache curl tar \
    && mkdir /plugin \
    && curl -fsSL "https://github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /plugin --strip-components=1 \
    && cd /plugin \
    && find . -mindepth 1 -maxdepth 1 \
        ! -name .traefik.yml ! -name LICENSE ! -name go.mod ! -name go.sum \
        ! -name '*.go' ! -name pkg ! -name vendor \
        -exec rm -rf {} + \
    && find . -name '*_test.go' -delete \
    && chmod -R a+rX,go-w /plugin

FROM scratch

COPY --from=source /plugin /

LABEL org.opencontainers.image.source="https://github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin"
