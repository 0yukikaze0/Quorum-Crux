FROM alpine:3.8

RUN apk add --no-cache --update unzip db zlib wrk wget libsodium-dev go bash libpthread-stubs db-dev && \
    apk -X http://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache leveldb && \
    apk --no-cache --update add build-base cmake boost-dev git

ENV PORT=""
ENV NODE_KEY=""
ENV CRUX_PUB=""
ENV GETH_KEY=""
ENV OWN_URL=""
ENV CRUX_PRIV=""
ENV OTHER_NODES=""
ENV GETH_RPC_PORT=""
ENV GETH_PORT=""

WORKDIR /quorum

COPY scripts/bootstrap.sh bootstrap.sh
COPY scripts/istanbul-init.sh istanbul-init.sh
COPY scripts/crux-start.sh crux-start.sh
COPY scripts/istanbul-start.sh istanbul-start.sh
COPY scripts/start.sh start.sh
COPY scripts/simpleContract.js simpleContract.js
COPY scripts/test_transaction.sh test_transaction.sh
COPY config/istanbul-genesis.json istanbul-genesis.json
COPY config/passwords.txt passwords.txt

RUN chmod +x *.sh && \
    ./bootstrap.sh && \
    apk del sed make git cmake build-base gcc g++ musl-dev curl-dev boost-dev

EXPOSE 9000 21000 22000

# Entrypoint for container
ENTRYPOINT ["./start.sh"]
