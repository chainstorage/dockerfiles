Usage:
------

Prepare: (optional)

    mkdir -p ~/geth/data ~/geth/logs ~/geth/config ~/geth/secrets 

Run:
    
    docker run --name geth  -v "$HOME/geth/data:/data" \
                                -v "$HOME/geth/logs:/logs" \
                                -v "$HOME/geth/config:/config" \
                                -v "$HOME/geth/secrets:/secrets" \
                                -p 9003:9001 \
                                -p 8545:8545 \
                                chainstorage/geth


Manage:
-------
You can use default supervisord methods and module [CryptoCurrencies Unified Remote Procedure Call interface](https://github.com/chainstorage/CCUnRPC) 

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').supervisor.stopProcess('ccdaemon:geth')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').supervisor.startProcess('ccdaemon:geth')"

    # CCUnRPC 
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').ccunrpc.get_height()"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').ccunrpc.get_status()"

     
