# ----------------------------------------------------------------------
# Etapa 1: Construcción (Build)
# ----------------------------------------------------------------------
FROM node:20-slim as builder
WORKDIR /app

# Silenciar el aviso de actualización de npm en los logs de Cloud Build
ENV NPM_CONFIG_UPDATE_NOTIFIER=false

# Copia los archivos de configuración de dependencias
COPY package.json package-lock.json ./

# ¡CORRECCIÓN AQUÍ!: Instalamos TODAS las dependencias (incluyendo Astro)
RUN npm ci

# Copia el código fuente completo
COPY . .

# Asegurar permisos de ejecución en los binarios locales por si acaso
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

# Copia tu configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia los archivos estáticos finales (la etapa Nginx no se queda con node_modules)
COPY --from=builder /app/dist .

# El servidor Nginx escucha por defecto en el puerto 80
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]