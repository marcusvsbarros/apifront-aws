# Etapa 1: build da aplicação React
FROM node:18-alpine as build

# Diretório de trabalho
WORKDIR /app

# Copia arquivos de dependências e instala
COPY package*.json ./
RUN npm install --force

# Copia o restante dos arquivos e constrói a aplicação
COPY . .
RUN npm run build

# Etapa 2: servidor Nginx para servir os arquivos estáticos
FROM nginx:stable-alpine

# Remove o conteúdo padrão do Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia os arquivos da build React para o Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Copia o arquivo de configuração customizado do Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Expondo a porta 80 para acesso externo
EXPOSE 80

# Inicia o Nginx
CMD ["nginx", "-g", "daemon off;"]