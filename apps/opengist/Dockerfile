ARG VERSION
FROM ghcr.io/thomiceli/opengist:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:d51381287f0739a8dfb22870b67f0afd5ac9400a89d9891f37adb4b058dd00dc /landrun /landrun

# git runs per-repo hooks from /config/repos, absent on a fresh volume; landrun rejects missing paths
ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/bin,/app", "--ro=/etc,/proc,/sys/fs/cgroup", "--rw=/tmp,/dev/null", "--rwx=/config", "--bind-tcp=80", "--connect-tcp=443,53,80", "--", "/app/opengist/opengist"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/thomiceli/opengist"
