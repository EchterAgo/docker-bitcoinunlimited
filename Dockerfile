FROM debian:stable-slim

LABEL maintainer.0="Axel Gembe (derago@gmail.com)"

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV BITCOIN_VERSION=1.7.0.0
ENV BITCOIN_FILENAME=BUcash-${BITCOIN_VERSION}-linux64.tar.gz
ENV BITCOIN_URL=https://www.bitcoinunlimited.info/downloads/${BITCOIN_FILENAME}
ENV BITCOIN_SHA256=4122a3e25e963e4f63f82c931fbdad42500611533f93c8d89ed3570d6f54eb05
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/BUcash-${BITCOIN_VERSION}/bin:$PATH

RUN set -ex \
  && curl -SLO "$BITCOIN_URL" \
  && echo "$BITCOIN_SHA256 $BITCOIN_FILENAME" | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
