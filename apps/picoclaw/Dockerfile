FROM docker.io/library/alpine:3.23

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV PICOCLAW_HOME="/config"

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        jq \
        tzdata \
    && \
    case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x86_64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && mkdir -p /app/bin \
    && curl -fsSL "https://github.com/sipeed/picoclaw/releases/download/v${VERSION}/picoclaw_Linux_${ARCH}.tar.gz" \
        | tar xzf - -C /app/bin picoclaw \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY ./apps/picoclaw/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

EXPOSE 18790

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/sipeed/picoclaw"
