FROM --platform=$BUILDPLATFORM docker.io/library/golang:1.26-alpine AS build

ARG VERSION
ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH

WORKDIR /src

COPY ./apps/landrun/env-all.patch /tmp/env-all.patch

#hadolint ignore=DL3018
RUN apk add --no-cache patch \
    && wget -qO- "https://github.com/Zouuup/landrun/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - --strip-components=1 \
    && patch -p1 < /tmp/env-all.patch \
    && go build -trimpath -ldflags='-s -w' -o /landrun ./cmd/landrun

FROM scratch

COPY --from=build /landrun /landrun

LABEL org.opencontainers.image.source="https://github.com/Zouuup/landrun"
