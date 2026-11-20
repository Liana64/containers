ARG VERSION
FROM ghcr.io/netsampler/goflow2:v${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:bad5500bd0e4e1e2e9b85a3691a86ddae2b687f3cf178c557b5d92fe4b986348 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/", "--bind-tcp=8080", "--", "/goflow2"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/netsampler/goflow2"
