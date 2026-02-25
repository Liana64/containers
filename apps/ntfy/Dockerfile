FROM docker.io/library/alpine:3.23

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV NTFY_LISTEN_HTTP=":8080" \
    NTFY_CACHE_FILE="/config/cache.db" \
    NTFY_ATTACHMENT_CACHE_DIR="/config/attachments"

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        jo \
        jq \
        nano \
        tzdata \
    && \
    case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='amd64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && mkdir -p /app/bin \
    && curl -fsSL "https://github.com/binwiederhier/ntfy/releases/download/v${VERSION}/ntfy_${VERSION}_linux_${ARCH}.tar.gz" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY ./apps/ntfy/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/binwiederhier/ntfy"
