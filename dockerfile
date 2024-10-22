# img nodejs (inclut npm)
FROM node:22.10.0

# Defini le working dir du conteneur
WORKDIR /app

# copie le dir du conteneur
COPY ./pong ./app

# EXPOSE 3000

