ARG VERSION
FROM ghcr.io/techarohq/anubis:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:bad5500bd0e4e1e2e9b85a3691a86ddae2b687f3cf178c557b5d92fe4b986348 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/ko-app", "--ro=/etc,/config,/var/run/ko,/proc,/sys/fs/cgroup", "--bind-tcp=8080,9090", "--connect-tcp=53", "--", "/ko-app/anubis"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/TecharoHQ/anubis"
