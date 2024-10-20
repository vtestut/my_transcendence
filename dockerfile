FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

RUN npm install hardhat

COPY . .

RUN chmod +x /usr/src/app/entrypoint.sh

EXPOSE 8545

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
