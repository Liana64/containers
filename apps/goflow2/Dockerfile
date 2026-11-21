ARG VERSION
FROM ghcr.io/netsampler/goflow2:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.2.0@sha256:1b0710e7bf89a963438cf117af104e963bd1bcf1f839b0c97729ea85de2f9153 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/", "--bind-tcp=8080", "--", "/goflow2"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/netsampler/goflow2"
