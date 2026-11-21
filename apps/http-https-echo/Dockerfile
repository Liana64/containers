ARG VERSION
FROM ghcr.io/mendhak/http-https-echo:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.2.0@sha256:1b0710e7bf89a963438cf117af104e963bd1bcf1f839b0c97729ea85de2f9153 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--bind-tcp=8080,8443", "--connect-tcp=53", "--"]
CMD ["node", "./index.js"]

LABEL org.opencontainers.image.source="https://github.com/mendhak/docker-http-https-echo"
