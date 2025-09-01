# services/api/Dockerfile
FROM golang:1.22-alpine AS builder

# Herramientas necesarias para bajar módulos y certificados TLS
RUN apk add --no-cache ca-certificates git

WORKDIR /app

# Descarga dependencias (usa proxy público de Go)
COPY go.mod ./
RUN go env -w GOPROXY=https://proxy.golang.org,direct && go mod download

# Copia el resto del código y compila (todos los paquetes)
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o api ./...

# Imagen final mínima con certificados
FROM gcr.io/distroless/base
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/api /api

EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/api"]

