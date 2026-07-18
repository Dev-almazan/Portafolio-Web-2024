# ----------------------------------------------------------------------
# Etapa 1: Construcción (Build)
# ----------------------------------------------------------------------
FROM node:20-slim as builder
WORKDIR /app

# Copia los archivos de configuración de dependencias
COPY package.json package-lock.json ./
# Instala dependencias
RUN npm ci --omit=dev

# Copia el código fuente completo
COPY . .
# Ejecuta el build estático de Astro (por defecto, los archivos van a /app/dist)
RUN npm run build 

# ----------------------------------------------------------------------
# Etapa 2: Servidor (Serve)
# ----------------------------------------------------------------------
FROM nginx:stable-alpine
# Este directorio DEBE coincidir con la directiva 'root' en tu nginx.conf
# Por defecto, Nginx usa /usr/share/nginx/html
WORKDIR /usr/share/nginx/html

# Elimina la configuración por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia la configuración de Nginx que acabamos de definir
# Asumiremos que el archivo se llama nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia los archivos estáticos de la etapa 'builder'
# La ruta /app/dist debe ser la carpeta de salida de tu build de Astro
COPY --from=builder /app/dist .

# El servidor Nginx escucha por defecto en el puerto 80
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]