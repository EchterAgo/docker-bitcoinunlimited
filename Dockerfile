FROM debian:stable-slim
LABEL maintainer="Axel Gembe <derago@gmail.com>"

ENV BITCOIN_VERSION=1.9.0.0
ENV BITCOIN_FILENAME=bch-unlimited-${BITCOIN_VERSION}-linux64.tar.gz
ENV BITCOIN_URL=https://www.bitcoinunlimited.info/downloads/${BITCOIN_FILENAME}
ENV BITCOIN_SHA256=81fef8b1422a50fd49d64dba9c0dc6420663d436dfcea6c066e0f0561a753c92
ENV BITCOIN_DATA=/data
ENV PATH=/opt/bch-unlimited-${BITCOIN_VERSION}/bin:$PATH

RUN set -ex && \
    apt-get update -y && \
    apt-get install -y curl libjemalloc2 && \
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

ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
