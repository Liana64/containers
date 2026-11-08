FROM docker.io/library/golang:1.27-alpine AS build

ARG VERSION

ENV CGO_ENABLED=0

RUN go install -trimpath -ldflags='-s -w' "github.com/zouuup/landrun/cmd/landrun@v${VERSION}"

FROM scratch

COPY --from=build /go/bin/landrun /landrun

LABEL org.opencontainers.image.source="https://github.com/Zouuup/landrun"
