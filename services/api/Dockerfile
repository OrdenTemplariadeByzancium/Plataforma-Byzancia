# ---- Build stage ----
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Dependencias mínimas para módulos y TLS
RUN apk add --no-cache git ca-certificates

# Cache de módulos
COPY go.mod go.sum ./
RUN go mod download

# Código y build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api ./...

# ---- Runtime stage ----
FROM gcr.io/distroless/base
WORKDIR /app
COPY --from=builder /app/api /app/api
EXPOSE 8080
ENTRYPOINT ["/app/api"]
