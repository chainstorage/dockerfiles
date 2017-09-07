Repo for currency Dockerfile
============================
Dockerfiles for cryptocurrencies daemons

Requirements:
------------


Build:
------

    docker build -t 'bitcoind:0.14.2_001' git@gitlab.kitchen.loc:cecilia/dockerfiles.git#master:bitcoind
    docker tag bitcoind:0.14.2_001 chainstorage/bitcoind:0.14.2_001
    docker push chainstorage/bitcoind:0.14.2_001

    docker tag chainstorage/bitcoind:0.14.2_001 chainstorage/bitcoind
    docker push chainstorage/bitcoind

Usage:
------

    # Run
    docker run --name bitcoind -v "~/bitcoind/data:/data" -v "~/bitcoind/logs:/logs" -v "~/bitcoind/config:/config" -p 9001:9001 -p 8332:8332 chainstorage/bitcoind

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').supervisor.stopProcess('bitcoind')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').supervisor.startProcess('bitcoind')"

    # Bitcoin RPC client:
    curl -s --user rpcuser:rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/ |jq .result.blocks


CCUnRPC:
--------

[CryptoCurrencies Unified Remote Procedure Call interface.](https://github.com/chainstorage/CCUnRPC)

