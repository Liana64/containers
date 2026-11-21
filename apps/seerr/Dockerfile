ARG VERSION
FROM ghcr.io/seerr-team/seerr:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.2.0@sha256:1b0710e7bf89a963438cf117af104e963bd1bcf1f839b0c97729ea85de2f9153 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib,/bin", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--rw=/app/config,/tmp,/app/.next/cache", "--bind-tcp=5055", "--connect-tcp=443,5055,7878,8096,8989,53", "--"]
CMD ["npm", "start"]

LABEL org.opencontainers.image.source="https://github.com/seerr-team/seerr"
