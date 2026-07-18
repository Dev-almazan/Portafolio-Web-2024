# ----------------------------------------------------------------------
# Etapa 1: Instalación y Compilación
# ----------------------------------------------------------------------
FROM node:20 AS builder
WORKDIR /app

ENV NPM_CONFIG_UPDATE_NOTIFIER=false

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Solución al Permission Denied: Forzamos permisos de ejecución en los binarios
RUN chmod -R +x node_modules/.bin

RUN npm run build

# ----------------------------------------------------------------------
# Etapa 2: Servidor en producción (El resto se queda igual)
# ----------------------------------------------------------------------
FROM node:20-slim AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NPM_CONFIG_UPDATE_NOTIFIER=false
ENV HOST=0.0.0.0
ENV PORT=8080

COPY package.json package-lock.json ./
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

CMD ["node", "./dist/server/entry.mjs"]