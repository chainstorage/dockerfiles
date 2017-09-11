Usage:
------

Prepare: (optional)

    mkdir -p ~/bitcoind/data ~/bitcoind/logs ~/bitcoind/config ~/bitcoind/secrets 

Run:
    
    docker run --name bitcoind  -v "~/bitcoind/data:/data" \
                                -v "~/bitcoind/logs:/logs" \
                                -v "~/bitcoind/config:/config" \
                                -v "~/bitcoind/secrets:/secrets" \                                
                                -p 9001:9003 \
                                -p 8332:8332 \
                                chainstorage/bitcoind


Manage:
-------
You can use default supervisord methods and module [CryptoCurrencies Unified Remote Procedure Call interface](https://github.com/chainstorage/CCUnRPC) 

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').supervisor.stopProcess('bitcoind')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').supervisor.startProcess('bitcoind')"

    # CCUnRPC 
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9003/RPC2').ccunrpc.get_height()"

     
