ARG VERSION
FROM ghcr.io/thomiceli/opengist:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:bad5500bd0e4e1e2e9b85a3691a86ddae2b687f3cf178c557b5d92fe4b986348 /landrun /landrun

# git runs per-repo hooks from /config/repos, absent on a fresh volume; landrun rejects missing paths
ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/bin,/app", "--ro=/etc,/proc,/sys/fs/cgroup", "--rw=/tmp,/dev/null", "--rwx=/config", "--bind-tcp=80", "--connect-tcp=443,53,80", "--", "/app/opengist/opengist"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/thomiceli/opengist"
