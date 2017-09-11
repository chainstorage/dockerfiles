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
 - `/config` - contain cc daemons config, supervisord. (Will not overwrite if you bid to local dir)
 - `/logs`
 - `/secrets` - for you wallets and other private data. (You have to save it at encrypted local storage if it's real money)


Manage:
-------
You can use default supervisord methods and module [CryptoCurrencies Unified Remote Procedure Call interface](https://github.com/chainstorage/CCUnRPC) 

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').supervisor.stopProcess('bitcoind')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').supervisor.startProcess('bitcoind')"

    # CCUnRPC 
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').ccunrpc.get_height()"