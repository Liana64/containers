ARG VERSION
FROM ghcr.io/seerr-team/seerr:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:bad5500bd0e4e1e2e9b85a3691a86ddae2b687f3cf178c557b5d92fe4b986348 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/bin", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--rw=/app/config,/tmp,/app/.next/cache", "--bind-tcp=5055", "--connect-tcp=443,5055,7878,8096,8989,53", "--"]
CMD ["npm", "start"]

LABEL org.opencontainers.image.source="https://github.com/seerr-team/seerr"
