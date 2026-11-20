ARG VERSION
FROM docker.io/alangrainger/immich-public-proxy:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:d51381287f0739a8dfb22870b67f0afd5ac9400a89d9891f37adb4b058dd00dc /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/sbin", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--rw=/tmp", "--bind-tcp=3000", "--connect-tcp=2283,53", "--", "/sbin/tini", "-s", "--"]
CMD ["node", "dist/index.js"]

LABEL org.opencontainers.image.source="https://github.com/alangrainger/immich-public-proxy"
