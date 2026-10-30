# ---- Build stage ----
FROM golang:1.27-alpine AS builder

WORKDIR /src

# Cache module downloads
COPY go.mod go.sum* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/time-microservice .

# ---- Runtime stage ----
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /out/time-microservice /time-microservice

EXPOSE 8080

ENTRYPOINT ["/time-microservice"]
