# docker/api/Dockerfile
FROM golang:1.22-alpine AS build
RUN apk add --no-cache git build-base
WORKDIR /src
# Ajusta estos COPY cuando tengas go.mod/go.sum en services/api
COPY services/api/go.mod services/api/go.sum ./ || true
RUN [ -f go.mod ] && go mod download || true
COPY services/api/ ./ || true
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    [ -d /src ] && go build -o /out/api ./cmd/api || true

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=build /out/api /app/api || true
EXPOSE 8080
CMD ["/app/api"]
