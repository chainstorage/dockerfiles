Repo for currency Dockerfile
============================
Dockerfiles for cryptocurrencies daemons

Requirements:
------------

Usage:
------

    # Run
    docker run --name parity -v "~/parity/data:/data" -v "~/parity/logs:/logs" -v "~/parity/config:/config" -p 9001:9002 -p 8332:8332 chainstorage/parity

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').supervisor.stopProcess('bitcoind')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').supervisor.startProcess('bitcoind')"


CCUnRPC:
--------

[CryptoCurrencies Unified Remote Procedure Call interface.](https://github.com/chainstorage/CCUnRPC)

     python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').ccunrpc.get_height()"
     