Usage:
------

Prepare: (optional)

    mkdir -p ~/neocli/data ~/neocli/logs ~/neocli/config ~/neocli/secrets

Run:
    
    docker run --name neocli  -v "$HOME/neocli/data:/data" \
                                -v "$HOME/neocli/logs:/logs" \
                                -v "$HOME/neocli/config:/config" \
                                -v "$HOME/neocli/secrets:/secrets" \
                                -p 9001:9003 \
                                -p 8332:8332 \
                                chainstorage/neocli


Manage:
-------
You can use default supervisord methods and module [CryptoCurrencies Unified Remote Procedure Call interface](https://github.com/chainstorage/CCUnRPC) 

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').supervisor.stopProcess('neocli')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').supervisor.startProcess('neocli')"

    # CCUnRPC 
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9001/RPC2').ccunrpc.get_height()"

     
