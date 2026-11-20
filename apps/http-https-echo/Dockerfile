ARG VERSION
FROM ghcr.io/mendhak/http-https-echo:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:bad5500bd0e4e1e2e9b85a3691a86ddae2b687f3cf178c557b5d92fe4b986348 /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--bind-tcp=8080,8443", "--connect-tcp=53", "--"]
CMD ["node", "./index.js"]

LABEL org.opencontainers.image.source="https://github.com/mendhak/docker-http-https-echo"
