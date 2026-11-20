ARG VERSION
FROM ghcr.io/mendhak/http-https-echo:${VERSION}

COPY --from=ghcr.io/liana64/landrun:0.1.17@sha256:d51381287f0739a8dfb22870b67f0afd5ac9400a89d9891f37adb4b058dd00dc /landrun /landrun

ENTRYPOINT ["/landrun", "--best-effort", "--log-level=info", "--env=*", "--rox=/usr,/lib", "--ro=/app,/etc,/proc,/sys/fs/cgroup", "--bind-tcp=8080,8443", "--connect-tcp=53", "--"]
CMD ["node", "./index.js"]

LABEL org.opencontainers.image.source="https://github.com/mendhak/docker-http-https-echo"
