ARG VERSION
FROM docker.io/alangrainger/immich-public-proxy:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:bad5500bd0e4e1e2e9b85a3691a86ddae2b687f3cf178c557b5d92fe4b986348 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/sbin", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--rw=/tmp", "--bind-tcp=3000", "--connect-tcp=2283,53", "--", "/sbin/tini", "-s", "--"]
CMD ["node", "dist/index.js"]

LABEL org.opencontainers.image.source="https://github.com/alangrainger/immich-public-proxy"
