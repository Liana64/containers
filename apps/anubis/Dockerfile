ARG VERSION
FROM ghcr.io/techarohq/anubis:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:d51381287f0739a8dfb22870b67f0afd5ac9400a89d9891f37adb4b058dd00dc /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/ko-app", "--ro=/etc,/config,/var/run/ko,/proc,/sys/fs/cgroup", "--bind-tcp=8080,9090", "--connect-tcp=53", "--", "/ko-app/anubis"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/TecharoHQ/anubis"
