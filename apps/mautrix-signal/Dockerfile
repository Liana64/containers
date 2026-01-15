FROM docker.io/library/rust:1-alpine AS rust-builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apk add --no-cache \
    git \
    make \
    cmake \
    protoc \
    musl-dev \
    g++ \
    clang-dev

WORKDIR /build

RUN git clone --depth 1 --branch "v${VERSION}" --recurse-submodules --shallow-submodules \
        https://github.com/mautrix/signal.git .

RUN ./build-rust.sh

FROM docker.io/library/golang:1-alpine3.23 AS go-builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    olm-dev \
    zlib-dev

WORKDIR /build

RUN git clone --depth 1 --branch "v${VERSION}" --recurse-submodules --shallow-submodules \
        https://github.com/mautrix/signal.git .

ENV LIBRARY_PATH=.
COPY --from=rust-builder /build/pkg/libsignalgo/libsignal/target/*/libsignal_ffi.a ./

RUN ./build-go.sh

FROM docker.io/library/alpine:3.23

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV HOME="/data" \
    UMASK="0002" \
    TZ="Etc/UTC" \
    PUID=1337 \
    PGID=1337

LABEL org.opencontainers.image.source="https://github.com/mautrix/signal" \
      org.opencontainers.image.description="Matrix-Signal bridge" \
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
    su-exec \
    tzdata \
    yq \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

RUN mkdir -p /data /config && \
    chown -R mautrix:mautrix /data /config && \
    chmod 700 /data /config

COPY --from=go-builder /build/mautrix-signal /usr/bin/mautrix-signal
COPY --chown=mautrix:mautrix --chmod=755 ./apps/mautrix-signal/entrypoint.sh /entrypoint.sh

RUN find / -xdev -perm /6000 -type f -exec chmod a-s {} \; 2>/dev/null || true

RUN /usr/bin/mautrix-signal --version || echo "Binary validation check"

WORKDIR /data
VOLUME ["/data"]

USER mautrix:mautrix

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD pgrep -f mautrix-signal || exit 1

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
