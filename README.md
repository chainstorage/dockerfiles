Repo for currency Dockerfile
============================
Universal way to manage cryptocurrencies daemons. 
Each container
 
Consist of:
----------
- `supervisord`
- `currensy daemon` (managed by supervisord)
- `something else` which depends on daemon (managed by supervisord to)

Data dirs:
----------
 - `/data` - home dir for daemon, contain blockchain and etc
 - `/config` - contain cc daemons config, supervisord. (Will not overwrite if you bind to local dir)
 - `/logs`
 - `/secrets` - for you wallets and other private data. (You have to save it at encrypted local storage if it's real money)

Usage:
------

Prepare: (optional)

    mkdir -p ~/parity/data ~/parity/logs ~/parity/config ~/parity/secrets

Run (example):
    
    docker run --name parity -v "~/parity/data:/data" \
                             -v "~/parity/logs:/logs" \
                             -v "~/parity/config:/config" \
                             -v "~/parity/secrets:/secrets" \
                             -p 9001:9002 \
                             -p 8332:8332 \
                             chainstorage/parity

Manage:
-------
You can use default supervisord methods and module [CryptoCurrencies Unified Remote Procedure Call interface](https://github.com/chainstorage/CCUnRPC) 

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').supervisor.stopProcess('parity')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').supervisor.startProcess('parity')"

    # CCUnRPC 
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').ccunrpc.get_height()"