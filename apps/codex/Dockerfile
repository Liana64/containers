FROM docker.io/library/node:22-bookworm-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

# xz-utils is only needed to unpack the nix tarball; purged after install
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
        xz-utils \
    && npm install -g "@openai/codex@${VERSION}" \
    && npm cache clean --force \
    && usermod -l codex -d /home/codex -m node \
    && groupmod -n codex node \
    && mkdir -p /workspace /home/codex/.codex /nix /etc/nix \
    && printf 'experimental-features = nix-command flakes\nbuild-users-group =\n' > /etc/nix/nix.conf \
    && chown -R codex:codex /workspace /home/codex/.codex /nix \
    && runuser -u codex -- env HOME=/home/codex \
        sh -c 'curl -L https://nixos.org/nix/install | sh -s -- --no-daemon --no-channel-add --no-modify-profile' \
    && apt-get purge -y xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY ./apps/codex/entrypoint.sh /entrypoint.sh

ENV PATH="/nix/var/nix/profiles/default/bin:${PATH}"

USER codex
WORKDIR /workspace

VOLUME ["/workspace"]

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/openai/codex"
