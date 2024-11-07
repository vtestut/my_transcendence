# img nodejs (inclut npm)
FROM node:22.10.0

WORKDIR /blockchain

COPY  . /blockchain

RUN chmod +x /blockchain/init.sh

RUN /blockchain/init.sh

ENTRYPOINT ["/bin/bash"]
