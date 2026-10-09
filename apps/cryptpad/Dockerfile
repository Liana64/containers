ARG VERSION
FROM docker.io/cryptpad/cryptpad:version-${VERSION}

ARG TARGETPLATFORM
ARG CHANNEL

USER root

#hadolint ignore=DL3018
RUN apk add --no-cache catatonit

USER cryptpad

RUN ./install-onlyoffice.sh --accept-license

COPY ./apps/cryptpad/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD []

LABEL org.opencontainers.image.source="https://github.com/cryptpad/cryptpad"
