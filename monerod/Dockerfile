FROM ubuntu:16.04 as builder

ENV BIMONEROD v0.11.0.0
ENV BIMONEROD_URL https://downloads.getmonero.org/cli/monero-linux-x64-${BIMONEROD}.tar.bz2


# install main dependencies
RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates dirmngr bzip2 gpgv git wget


    ####################### DAEMON ###################################################
RUN set -ex \ 
    && BITMONEROD_DIST=$(basename $BIMONEROD_URL) \
    && wget -qO $BITMONEROD_DIST $BIMONEROD_URL \
    && tar -xjvf $BITMONEROD_DIST \
    && mkdir /artifact \
    && mv monero*/* /artifact


    ####################### SUPERVISORD ################################################
RUN  git clone https://github.com/chainstorage/CCUnRPC.git  /usr/lib/python2.7/dist-packages/ccunrpc/


#RUN groupadd -r bitmonero && useradd -r -m -g bitmonero bitmonero


FROM ubuntu:16.04
RUN groupadd -r bitmonero && useradd -r -m -g bitmonero bitmonero
RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends supervisor python-requests \
	&& rm -rf /var/lib/apt/lists/*;

COPY --from=0   /usr/lib/python2.7/dist-packages/ccunrpc/  /usr/lib/python2.7/dist-packages/ccunrpc/

RUN { set -ex; \
    mkdir /default; \
    mkdir /data;  \
    mkdir /secrets; \
    mkdir /config; \
    mkdir /logs; \
}
VOLUME ["/data", "/secrets", "/config", "/logs"]

COPY --from=0   /artifact /usr/bin/

COPY conf/* /default/

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 18080 18081 9001
