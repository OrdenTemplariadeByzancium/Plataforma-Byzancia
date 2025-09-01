FROM golang:1.22-alpine AS builder
WORKDIR /app

# El contexto será services/api, así que go.mod está aquí mismo
COPY go.mod ./
RUN go mod download

COPY . .
# Si tu main.go está en la raíz de services/api:
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api .
# Si usas cmd/api/main.go, sería:
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api ./cmd/api

FROM gcr.io/distroless/base
COPY --from=builder /app/api /api
EXPOSE 8080
ENTRYPOINT ["/api"]

