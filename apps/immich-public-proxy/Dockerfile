ARG VERSION
FROM docker.io/alangrainger/immich-public-proxy:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.2.0@sha256:1b0710e7bf89a963438cf117af104e963bd1bcf1f839b0c97729ea85de2f9153 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/sbin", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--rw=/tmp", "--bind-tcp=3000", "--connect-tcp=2283,53", "--", "/sbin/tini", "-s", "--"]
CMD ["node", "dist/index.js"]

LABEL org.opencontainers.image.source="https://github.com/alangrainger/immich-public-proxy"
