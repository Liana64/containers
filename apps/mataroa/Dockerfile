FROM docker.io/library/python:3.13-alpine
LABEL org.opencontainers.image.source="https://github.com/isaiasghezae/unique-turker-2"

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    EXPOSED_URL="REPLACE_ME" \
    EXPOSED_PROTO="HTTPS" \
    CONFIG_DB="/config/database.db"

USER root
WORKDIR /app

RUN apk add --no-cache \
    bash \
    catatonit \
    swig \
    gcc \
    musl-dev \
    linux-headers \
    coreutils \
    curl \
    jq \
    nano \
    tzdata \
    git \
    && case "${CHANNEL}" in \
    'stable') \
    curl -fsSL "https://github.com/mataroa-blog/mataroa/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    ;; \
    'beta') \
    git clone https://github.com/mataroa-blog/mataroa.git /tmp/app \
    cp -R /tmp/app /app \
    ;; \
    esac \
    && pip install uv \
    && uv pip install --system --requirements /app/requirements.in \
    && chown -R nobody:nogroup /app && chmod -R 755 /app \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY ./apps/mataroa/entrypoint.sh /entrypoint.sh

USER nobody:nogroup

EXPOSE 8000

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
