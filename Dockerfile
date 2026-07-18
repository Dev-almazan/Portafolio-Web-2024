# ----------------------------------------------------------------------
# Etapa 1: Construcción (Build)
# ----------------------------------------------------------------------
FROM node:20-slim as builder
WORKDIR /app

# Silenciar el aviso de actualización de npm en los logs de Cloud Build
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

# Copia los archivos de configuración de dependencias
COPY package.json package-lock.json ./

# Instala TODAS las dependencias (necesarias para compilar Astro)
RUN npm ci

# Copia el código fuente completo del portafolio
COPY . .

# Asegura permisos de ejecución en los binarios locales
RUN chmod -R +x node_modules/.bin

# Ejecuta el build estático de Astro (genera la carpeta /app/dist)
RUN npm run build 

# ----------------------------------------------------------------------
# Etapa 2: Servidor (Serve)
# ----------------------------------------------------------------------
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# Elimina la configuración por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia tu archivo como plantilla para que Nginx inyecte el puerto de Cloud Run dinámicamente
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Copia los archivos estáticos finales desde la etapa de compilación
COPY --from=builder /app/dist .

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]