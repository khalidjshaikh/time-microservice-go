#!/usr/bin/env bash
# Run the test suite with race detection and coverage.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

go test ./... -v -race -count=1 -coverprofile=coverage.out -covermode=atomic
echo ""
echo "Coverage summary:"
go tool cover -func=coverage.out | tail -n 5
