FROM docker.io/library/python:3.14-slim AS build

ARG VERSION

ENV \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_ROOT_USER_ACTION=ignore

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
    && python -m venv /opt/venv \
    && /opt/venv/bin/pip install "hermes-agent[all,messaging,anthropic]==${VERSION}" \
    && /opt/venv/bin/pip uninstall -y pip wheel

FROM docker.io/library/python:3.14-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:${PATH}"

ENV UMASK="0002" \
    TZ="Etc/UTC"

# lazy installs write to site-packages, impossible as nobody
ENV HOME="/config" \
    HERMES_HOME="/config" \
    HERMES_DISABLE_LAZY_INSTALLS=1

USER root

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        catatonit \
        curl \
        git \
        jq \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && pip uninstall -y pip wheel \
    && rm -rf /root/.cache /tmp/*

COPY --from=build /opt/venv /opt/venv
COPY ./apps/hermes-agent/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/NousResearch/hermes-agent"
