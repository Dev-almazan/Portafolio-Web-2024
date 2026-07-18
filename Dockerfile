# ----------------------------------------------------------------------
# Etapa 1: Instalación y Compilación (Usamos la imagen completa para asegurar herramientas)
# ----------------------------------------------------------------------
FROM node:20 AS builder
WORKDIR /app

ENV NPM_CONFIG_UPDATE_NOTIFIER=false

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
# Forzamos la ejecución limpia del build
RUN npm run build

# ----------------------------------------------------------------------
# Etapa 2: Servidor en producción (Mantenemos la imagen ligera)
# ----------------------------------------------------------------------
FROM node:20-slim AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NPM_CONFIG_UPDATE_NOTIFIER=false
ENV HOST=0.0.0.0
ENV PORT=8080

COPY package.json package-lock.json ./
RUN npm ci --only=production

# Copiamos el build generado por el adaptador de Node desde la etapa builder
COPY --from=builder /app/dist ./dist

CMD ["node", "./dist/server/entry.mjs"]