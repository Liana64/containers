ARG VERSION
FROM docker.io/crowdsecurity/crowdsec:v${VERSION}

ARG TARGETPLATFORM
ARG CHANNEL

USER root

COPY ./apps/crowdsec/config.yaml.local /tmp/config.yaml.local

#hadolint ignore=DL3018
RUN \
    apk add --no-cache catatonit \
    && mkdir -p /etc/crowdsec \
    && install -d -o nobody -g nogroup /var/lib/crowdsec/db \
    && cp -a /staging/etc/crowdsec/. /etc/crowdsec/ \
    && cp -a /staging/var/lib/crowdsec/data/. /var/lib/crowdsec/data/ \
    && cscli hub update \
    && cscli collections install crowdsecurity/traefik \
    && mv /tmp/config.yaml.local /etc/crowdsec/config.yaml.local \
    && rm -rf \
        /docker_start.sh \
        /staging \
        /etc/crowdsec/local_api_credentials.yaml \
        /etc/crowdsec/online_api_credentials.yaml \
        /var/lib/crowdsec/data/crowdsec.db* \
    && chmod -R a+rX /etc/crowdsec /var/lib/crowdsec

COPY ./apps/crowdsec/entrypoint.sh /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/crowdsecurity/crowdsec"
