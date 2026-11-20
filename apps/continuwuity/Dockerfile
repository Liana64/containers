ARG VERSION
FROM forgejo.ellis.link/continuwuation/continuwuity:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:d51381287f0739a8dfb22870b67f0afd5ac9400a89d9891f37adb4b058dd00dc /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/sbin,/lib64,/usr", "--ro=/etc", "--rw=/data,/tmp", "--bind-tcp=8008", "--connect-tcp=443,8448,53", "--"]
CMD ["/sbin/conduwuit"]

LABEL org.opencontainers.image.source="https://forgejo.ellis.link/continuwuation/continuwuity"
