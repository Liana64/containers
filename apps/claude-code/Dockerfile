FROM docker.io/library/node:22-bookworm-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        jq \
        openssh-client \
        passwd \
        ripgrep \
        tini \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g "@anthropic-ai/claude-code@${VERSION}" \
    && npm cache clean --force \
    && usermod -l claude -d /home/claude -m node \
    && groupmod -n claude node \
    && mkdir -p /workspace /home/claude/.claude \
    && chown -R claude:claude /workspace /home/claude/.claude

COPY ./apps/claude-code/entrypoint.sh /entrypoint.sh

USER claude
WORKDIR /workspace
VOLUME ["/workspace"]

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/anthropics/claude-code"
