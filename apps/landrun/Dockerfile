FROM --platform=$BUILDPLATFORM docker.io/library/golang:1.26-alpine AS build

ARG VERSION
ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH

WORKDIR /src

COPY ./apps/landrun/env-all.patch /tmp/env-all.patch

#hadolint ignore=DL3018
RUN apk add --no-cache patch \
    && go mod download "github.com/zouuup/landrun@v${VERSION}" \
    && cp -r "$(go env GOMODCACHE)/github.com/zouuup/landrun@v${VERSION}/." . \
    && chmod -R u+w . \
    && patch -p1 < /tmp/env-all.patch \
    && go build -trimpath -ldflags='-s -w' -o /landrun ./cmd/landrun

FROM scratch

COPY --from=build /landrun /landrun

LABEL org.opencontainers.image.source="https://github.com/Zouuup/landrun"
