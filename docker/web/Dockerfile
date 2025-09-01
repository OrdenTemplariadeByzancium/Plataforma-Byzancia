# docker/web/Dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY services/web/package*.json ./ || true
RUN [ -f package.json ] && npm ci || true
COPY services/web/ ./ || true
RUN [ -f package.json ] && npm run build || true

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html 2>/dev/null || true
EXPOSE 80
