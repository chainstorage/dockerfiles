FROM ubuntu:16.04

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr supervisor python-requests gpgv git wget \
	&& rm -rf /var/lib/apt/lists/*

RUN groupadd --system geth \
	&& useradd --system --create-home --gid geth geth

ENV GETH_VERSION 1.7.3-4bb3c89d
ENV GETH_URL https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-${GETH_VERSION}.tar.gz

# install geth binaries
RUN set -ex \
	&& GETH_DIST=$(basename $GETH_URL) \
	&& wget --quiet -O $GETH_DIST $GETH_URL \
	&& tar -xzvf $GETH_DIST -C /usr/local/bin --strip-components=1 \
	&& rm geth*

RUN { set -ex; \
    mkdir /default; \
    mkdir /data; chown -R geth:geth /data; \
    mkdir /secrets; chown -R geth:geth /secrets;\
    mkdir /config; \
    mkdir /logs; \
}
VOLUME ["/data", "/secrets", "/config", "/logs"]

COPY conf/* /default/

# supervisor
RUN { set -ex; \
    git clone https://github.com/chainstorage/CCUnRPC.git /usr/lib/python2.7/dist-packages/ccunrpc/; \
    mkdir -p /var/run; \
}

COPY entrypoint_lib.sh /entrypoint_lib.sh
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8545 8546 30303 9001
