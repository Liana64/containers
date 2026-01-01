FROM docker.io/library/golang:1.25-alpine3.23 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN addgroup -g 1337 -S mautrix && \
    adduser -u 1337 -S mautrix -G mautrix

RUN apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    olm-dev \
    curl \
    jq

WORKDIR /build

RUN case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='amd64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && RELEASE_URL=$(curl -sX GET "https://api.github.com/repos/mautrix/twitter/releases/latest" | jq -r '.tarball_url') \
    && if [[ "${RELEASE_URL}" != "null" && -n "${RELEASE_URL}" ]]; then \
        curl -fsSL "${RELEASE_URL}" | tar xzf - -C /tmp --strip-components=1; \
    else \
        curl -fsSL "https://api.github.com/repos/mautrix/twitter/tarball/${VERSION}" | tar xzf - -C /tmp --strip-components=1; \
    fi \
    && cp -r /tmp/* /build/ \
    && chown -R mautrix:mautrix /build

USER mautrix:mautrix

RUN ./build.sh

FROM docker.io/library/alpine:3.23

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    HOME="/data" \
    PYTHONUNBUFFERED=1 \
    UMASK="0002" \
    TZ="Etc/UTC" \
    PUID=1337 \
    PGID=1337

LABEL org.opencontainers.image.source="https://github.com/mautrix/twitter" \
      org.opencontainers.image.description="Matrix-Twitter bridge" \
      org.opencontainers.image.licenses="AGPL-3.0" \
      org.opencontainers.image.version="${VERSION}"

RUN addgroup -g 1337 -S mautrix && \
    adduser -u 1337 -S mautrix -G mautrix

RUN apk add --no-cache \
    bash \
    ca-certificates \
    catatonit \
    curl \
    ffmpeg \
    jq \
    olm \
    tzdata \
    yq \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

RUN mkdir -p /data /config && \
    chown -R mautrix:mautrix /data /config && \
    chmod 700 /data /config

COPY --from=builder --chown=mautrix:mautrix /build/mautrix-twitter /usr/bin/mautrix-twitter
COPY --chown=mautrix:mautrix --chmod=755 ./apps/mautrix-twitter/entrypoint.sh /entrypoint.sh

RUN find / -xdev -perm /6000 -type f -exec chmod a-s {} \; 2>/dev/null || true

RUN /usr/bin/mautrix-twitter --version || echo "Binary validation check"

WORKDIR /data
VOLUME ["/data"]

USER mautrix:mautrix

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD pgrep -f mautrix-twitter || exit 1

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
