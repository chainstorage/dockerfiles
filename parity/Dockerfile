FROM ubuntu:16.04 as builder

ENV PARITY_VERSION v1.7.9
ENV DEPS_FOR_RUNING supervisor python-requests ca-certificates openssl
ENV DEPS_FOR_BUILDING g++ build-essential curl git file libssl-dev pkg-config libudev-dev

RUN { set -ex; \
    # install deps
    apt-get update; \
    apt-get install --no-install-recommends -y $DEPS_FOR_RUNING $DEPS_FOR_BUILDING; \

    ####################### DAEMON ###################################################
    curl https://sh.rustup.rs -sSf | sh -s -- -y; \
    export PATH=/root/.cargo/bin:${PATH}; \

	# show tool versions
	rustc -vV; \
	cargo -V; \
	gcc -v; \
	g++ -v; \

	# download
    git clone https://github.com/paritytech/parity /tmp/parity --depth 1 --branch $PARITY_VERSION; \
    cd /tmp/parity; \
    git checkout $PARITY_VERSION; \

    # build & install
    export RUST_BACKTRACE=1; \
    cargo build --release --features final --verbose; \
    cp target/release/parity /usr/bin; \
    rm -rf /root/.cargo /root/.rustup; \

    ####################### SUPERVISORD ################################################
    git clone https://github.com/chainstorage/CCUnRPC.git  /usr/lib/python2.7/dist-packages/ccunrpc/; \
    mkdir -p  /var/run; \

}
#ENTRYPOINT bash
FROM ubuntu:16.04

ENV DEPS_FOR_RUNING supervisor python-requests ca-certificates openssl

RUN { set -ex; \
    # install deps
    apt-get update; \
    apt-get install --no-install-recommends -y $DEPS_FOR_RUNING ; \
    rm -rf /var/lib/apt/lists/* ; \
}

COPY --from=0   /usr/lib/python2.7/dist-packages/ccunrpc/  /usr/lib/python2.7/dist-packages/ccunrpc/
COPY --from=0   /tmp/parity/target/release/parity /usr/bin


RUN { set -ex; \
    mkdir /default; \
    mkdir /data; \
    mkdir /secrets; \
    mkdir /config; \
    mkdir /logs; \
}
VOLUME ["/data", "/secrets", "/config", "/logs"]

COPY conf/* /default/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080 8545 8180 9001