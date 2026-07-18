# ----------------------------------------------------------------------
# Etapa 1: Instalación y Compilación
# ----------------------------------------------------------------------
FROM node:20-slim AS builder
WORKDIR /app

ENV NPM_CONFIG_UPDATE_NOTIFIER=false

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# ----------------------------------------------------------------------
# Etapa 2: Servidor en producción
# ----------------------------------------------------------------------
FROM node:20-slim AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

# Inyectamos las variables para que Astro escuche en la interfaz correcta y en el puerto de Cloud Run
ENV HOST=0.0.0.0
ENV PORT=8080

# Copiamos solo lo necesario para producción para mantener la imagen ligera
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Copiamos el build generado por el adaptador de Node
COPY --from=builder /app/dist ./dist

# Comando para iniciar el servidor nativo de Astro
CMD ["node", "./dist/server/entry.mjs"]