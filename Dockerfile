FROM debian:stable-slim
LABEL maintainer="Axel Gembe <derago@gmail.com>"

ENV BITCOIN_VERSION=1.8.0.0
ENV BITCOIN_FILENAME=bch-unlimited-${BITCOIN_VERSION}-linux64.tar.gz
ENV BITCOIN_URL=https://www.bitcoinunlimited.info/downloads/${BITCOIN_FILENAME}
ENV BITCOIN_SHA256=d36da1380e2b5c5412c52be958a7583bcab6d7a7bbb8057417eb892851e8bdd4
ENV BITCOIN_DATA=/data
ENV PATH=/opt/bch-unlimited-${BITCOIN_VERSION}/bin:$PATH

RUN set -ex && \
    apt-get update -y && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -SLO "$BITCOIN_URL" && \
    echo "$BITCOIN_SHA256 $BITCOIN_FILENAME" | sha256sum -c - && \
    tar -xzf *.tar.gz -C /opt && \
    rm *.tar.gz && \
    apt-get remove -y curl && \
    apt-get autoremove -y

VOLUME ["/data"]
RUN ln -s /data /.bitcoin

EXPOSE 8332 8333 18332 18333 18443 18444

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
