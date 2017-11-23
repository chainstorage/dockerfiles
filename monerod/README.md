Usage:
------

Prepare: (optional)

    DAEMON_NAME=monerod
    mkdir -p ~/$DAEMON_NAME/data ~/$DAEMON_NAME/logs ~/$DAEMON_NAME/config ~/$DAEMON_NAME/secrets

Run:
    
    docker run --name $DAEMON_NAME -v "$HOME/$DAEMON_NAME/data:/data" \
                             -v "$HOME/$DAEMON_NAME/logs:/logs" \
                             -v "$HOME/$DAEMON_NAME/config:/config" \
                             -v "$HOME/$DAEMON_NAME/secrets:/secrets" \
                             -p 9001:9002 \
                             -p 8332:8332 \
                             chainstorage/$DAEMON_NAME

Manage:
-------
You can use default supervisord methods and module [CryptoCurrencies Unified Remote Procedure Call interface](https://github.com/chainstorage/CCUnRPC) 

    # Supervisord RPC-client:
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').supervisor.stopProcess('bintmonerod')"
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').supervisor.startProcess('bitmonerod')"

    # CCUnRPC 
    python -c "import xmlrpclib;print xmlrpclib.ServerProxy('http://root:password@localhost:9002/RPC2').ccunrpc.get_height()"