Usage:
------

Prepare: (optional)

    mkdir -p ~/parity/data ~/parity/logs ~/parity/config ~/parity/secrets

Run:
    
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