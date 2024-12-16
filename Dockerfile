FROM node:23-alpine3.20 As base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .


FROM base AS builder

WORKDIR /usr/src/app
COPY server.js ./

FROM node:23.4-alpine3.21
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /usr/src/app/ ./

EXPOSE 8080
CMD ["npm","start"]

