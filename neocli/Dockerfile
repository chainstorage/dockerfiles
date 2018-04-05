FROM ubuntu:16.04

RUN groupadd --system --gid 19000 neo \
	&& useradd --system --uid 19000 --create-home --gid neo neo

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq ca-certificates dirmngr supervisor python-requests gpgv git wget apt-transport-https \
	libleveldb-dev sqlite3 libsqlite3-dev unzip \
	&& rm -rf /var/lib/apt/lists/*

# install microsoft NET core

RUN set -ex \
    && wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update \
    && apt-get install -qq dotnet-runtime-2.0.6

ENV NEO_VERSION 2.7.4
ENV NEO_URL https://github.com/neo-project/neo-cli/releases/download/v2.7.4/neo-cli-linux-x64.zip
ENV NEO_SHA256 1B07A92E2867770B2DC5CEF830C151EAE3354353BB0D782D1642FBF7C5DEBC01
ENV NEO_ROOT_DIR /opt

# install neo binaries
RUN set -ex \
	&& NEO_DIST=$(basename $NEO_URL) \
	&& wget -qO $NEO_DIST $NEO_URL \
	&& echo "$NEO_SHA256 $NEO_DIST" | sha256sum -c - \
	&& unzip $NEO_DIST -d $NEO_ROOT_DIR

RUN { set -ex; \
    mkdir /default; \
    mkdir /data; chown -R neo:neo /data; \
    mkdir /secrets; chown -R neo:neo /secrets;\
    mkdir /config; \
    mkdir /logs; \
}
VOLUME ["/data", "/secrets", "/config", "/logs"]

COPY conf/* /default/

# set default config
RUN set -ex \
    && rm $NEO_ROOT_DIR/neo-cli/config.json \
    && ln -s /default/config.json $NEO_ROOT_DIR/neo-cli/config.json

# supervisor
RUN { set -ex; \
    git clone https://github.com/chainstorage/CCUnRPC.git /usr/lib/python2.7/dist-packages/ccunrpc/; \
    mkdir -p /var/run; \
}

COPY ep_lib.sh /ep_lib.sh
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 10331 10332 10333 10334 9001
