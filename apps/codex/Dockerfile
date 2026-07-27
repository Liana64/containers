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
        less \
        openssh-client \
        passwd \
        procps \
        ripgrep \
        tini \
        tzdata \
        xz-utils \
    && npm install -g "@openai/codex@${VERSION}" \
    && npm cache clean --force \
    && case "${TARGETPLATFORM}" in \
        'linux/amd64') GOARCH='amd64'; RUSTARCH='x86_64' ;; \
        'linux/arm64') GOARCH='arm64'; RUSTARCH='aarch64' ;; \
    esac \
    && curl -fsSL -o /usr/local/bin/yq \
        "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${GOARCH}" \
    && curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_${RUSTARCH}-unknown-linux-gnu.tar.gz" \
        | tar xzf - -C /usr/local/bin ./eza \
    && chmod +x /usr/local/bin/yq /usr/local/bin/eza \
    && usermod -l codex -d /home/codex -m node \
    && groupmod -n codex node \
    && git config --system --add safe.directory '*' \
    && mkdir -p /workspace /home/codex/.codex /nix /etc/nix \
    && printf 'experimental-features = nix-command flakes\nbuild-users-group =\nsandbox = false\n' > /etc/nix/nix.conf \
    && chown -R codex:codex /workspace /home/codex/.codex /nix \
    && runuser -u codex -- env HOME=/home/codex \
        sh -c 'curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon --no-channel-add --no-modify-profile' \
    && apt-get purge -y xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY ./apps/codex/entrypoint.sh /entrypoint.sh

# single-user nix installs into $HOME/.nix-profile, not profiles/default
ENV HOME="/home/codex" \
    PATH="/home/codex/.nix-profile/bin:${PATH}"

USER codex
WORKDIR /workspace

VOLUME ["/workspace"]

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/openai/codex"
