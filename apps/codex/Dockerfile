FROM docker.io/library/node:22-bookworm-slim

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# renovate: datasource=github-releases depName=ajeetdsouza/zoxide
ARG ZOXIDE_VERSION=0.10.0
# renovate: datasource=github-releases depName=sharkdp/bat
ARG BAT_VERSION=0.26.1
# renovate: datasource=github-releases depName=sharkdp/fd
ARG FD_VERSION=10.4.2
# renovate: datasource=github-releases depName=dandavison/delta
ARG DELTA_VERSION=0.19.2
# renovate: datasource=github-releases depName=bootandy/dust
ARG DUST_VERSION=1.2.5
# renovate: datasource=github-releases depName=muesli/duf
ARG DUF_VERSION=0.9.1
# renovate: datasource=github-releases depName=aristocratos/btop
ARG BTOP_VERSION=1.4.7
# renovate: datasource=github-releases depName=fastfetch-cli/fastfetch
ARG FASTFETCH_VERSION=2.66.0
# renovate: datasource=github-releases depName=eza-community/eza
ARG EZA_VERSION=0.23.5
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.53.3

ARG CARGO_HOME=/usr/local/cargo

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    RUSTUP_HOME="/usr/local/rustup"

USER root
WORKDIR /app

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        bc \
        ca-certificates \
        curl \
        git \
        gnupg \
        iproute2 \
        jq \
        less \
        openssh-client \
        passwd \
        procps \
        ripgrep \
        tini \
        tzdata \
        uuid-runtime \
    && npm install -g "@openai/codex@${VERSION}" \
    && npm cache clean --force \
    && case "${TARGETPLATFORM}" in \
        'linux/amd64') GOARCH='amd64'; RUSTARCH='x86_64'; DUFARCH='x86_64'; DELTA_LIBC='musl' ;; \
        'linux/arm64') GOARCH='arm64'; RUSTARCH='aarch64'; DUFARCH='arm64'; DELTA_LIBC='gnu' ;; \
        *) echo "unsupported platform: ${TARGETPLATFORM}" >&2; exit 1 ;; \
    esac \
    && for spec in \
        "bat|https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-${RUSTARCH}-unknown-linux-musl.tar.gz" \
        "fd|https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-${RUSTARCH}-unknown-linux-musl.tar.gz" \
        "delta|https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${RUSTARCH}-unknown-linux-${DELTA_LIBC}.tar.gz" \
        "dust|https://github.com/bootandy/dust/releases/download/v${DUST_VERSION}/dust-v${DUST_VERSION}-${RUSTARCH}-unknown-linux-musl.tar.gz" \
    ; do \
        curl -fsSL "${spec#*|}" \
            | tar xzf - -C /usr/local/bin --strip-components=1 --wildcards "*/${spec%%|*}"; \
    done \
    && curl -fsSL "https://github.com/ajeetdsouza/zoxide/releases/download/v${ZOXIDE_VERSION}/zoxide-${ZOXIDE_VERSION}-${RUSTARCH}-unknown-linux-musl.tar.gz" \
        | tar xzf - -C /usr/local/bin zoxide \
    && curl -fsSL "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${DUFARCH}.tar.gz" \
        | tar xzf - -C /usr/local/bin duf \
    && curl -fsSL "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_${RUSTARCH}-unknown-linux-gnu.tar.gz" \
        | tar xzf - -C /usr/local/bin ./eza \
    && curl -fsSL "https://github.com/aristocratos/btop/releases/download/v${BTOP_VERSION}/btop-${RUSTARCH}-unknown-linux-musl.tar.gz" \
        | tar xzf - -C /usr/local/bin --strip-components=3 --wildcards '*/bin/btop' \
    && curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-${GOARCH}.tar.gz" \
        | tar xzf - -C /usr/local/bin --strip-components=3 --wildcards '*/usr/bin/fastfetch' \
    && curl -fsSL -o /usr/local/bin/yq \
        "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${GOARCH}" \
    && chmod 0755 /usr/local/bin/yq /usr/local/bin/eza \
    && curl -fsSL https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path --profile minimal \
            -c clippy -c rustfmt -c rust-analyzer -c rust-src \
    && chmod -R a+rX "${RUSTUP_HOME}" "${CARGO_HOME}" \
    && curl -fsSL https://api.github.com/meta \
        | jq -r '.ssh_keys[] | "github.com \(.)"' > /etc/ssh/ssh_known_hosts \
    && chmod 0644 /etc/ssh/ssh_known_hosts \
    && usermod -l codex -d /home/codex -m node \
    && groupmod -n codex node \
    && git config --system --add safe.directory '*' \
    && mkdir -p /workspace /home/codex/.ssh \
    && chown -R codex:codex /workspace /home/codex \
    && chmod 0700 /home/codex/.ssh \
    && rm -rf /var/lib/apt/lists/*

COPY ./apps/codex/ssh_config /etc/ssh/ssh_config.d/10-codex.conf
COPY ./apps/codex/entrypoint.sh /entrypoint.sh

ENV PATH="/usr/local/cargo/bin:${PATH}"

USER codex
WORKDIR /workspace

VOLUME ["/workspace"]

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/openai/codex"
