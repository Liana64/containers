ARG VERSION
FROM ghcr.io/seerr-team/seerr:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:d51381287f0739a8dfb22870b67f0afd5ac9400a89d9891f37adb4b058dd00dc /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/bin", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--rw=/app/config,/tmp,/app/.next/cache", "--bind-tcp=5055", "--connect-tcp=443,5055,7878,8096,8989,53", "--"]
CMD ["npm", "start"]

LABEL org.opencontainers.image.source="https://github.com/seerr-team/seerr"
