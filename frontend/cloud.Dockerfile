FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

# Install a simple HTTPS server
RUN npm install -g http-server

CMD ["http-server", "build", "-p", "3000", "--ssl", "--cert", "/app/ssl/books.bchwy.com.crt", "--key", "/app/ssl/books.bchwy.com.key"]