#!/usr/bin/env bash
# Build the time-microservice-go binary for the host platform.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p bin

VERSION="${VERSION:-$(git describe --tags --always --dirty 2>/dev/null || echo dev)}"
COMMIT="${COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo none)}"
BUILD_DATE="${BUILD_DATE:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"

LDFLAGS="-s -w"
LDFLAGS="$LDFLAGS -X main.version=${VERSION}"
LDFLAGS="$LDFLAGS -X main.commit=${COMMIT}"
LDFLAGS="$LDFLAGS -X main.buildDate=${BUILD_DATE}"

GOOS="${GOOS:-}"
GOARCH="${GOARCH:-}"

if [[ -n "$GOOS" || -n "$GOARCH" ]]; then
  out="bin/time-microservice-go-${GOOS:-$(go env GOOS)}-${GOARCH:-$(go env GOARCH)}"
  CGO_ENABLED=0 GOOS="${GOOS:-$(go env GOOS)}" GOARCH="${GOARCH:-$(go env GOARCH)}" \
    go build -trimpath -ldflags "$LDFLAGS" -o "$out" .
  echo "Built $out"
else
  CGO_ENABLED=0 go build -trimpath -ldflags "$LDFLAGS" -o bin/time-microservice-go .
  echo "Built bin/time-microservice-go"
fi
