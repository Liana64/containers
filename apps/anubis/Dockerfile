ARG VERSION
FROM ghcr.io/techarohq/anubis:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/ko-app", "--ro=/etc,/config,/var/run/ko,/proc,/sys/fs/cgroup", "--bind-tcp=8080,9090", "--connect-tcp=53", "--", "/ko-app/anubis"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/TecharoHQ/anubis"
