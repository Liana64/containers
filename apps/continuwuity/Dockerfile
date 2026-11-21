ARG VERSION
FROM forgejo.ellis.link/continuwuation/continuwuity:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.2.0@sha256:1b0710e7bf89a963438cf117af104e963bd1bcf1f839b0c97729ea85de2f9153 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/sbin,/lib64,/usr", "--ro=/etc", "--rw=/data,/tmp", "--bind-tcp=8008", "--connect-tcp=443,8448,53", "--"]
CMD ["/sbin/conduwuit"]

LABEL org.opencontainers.image.source="https://forgejo.ellis.link/continuwuation/continuwuity"
