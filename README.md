
# docker-bitcoind

A Docker configuration with sane defaults for running a full validating
Bitcoin node.

**This configuration has been modified for to use the testnet and is being built directly instead of pulling from Dockerhub**

## Quick start

Requires that [Docker be installed](https://docs.docker.com/engine/installation/) on the host machine.

```
# Create some directory where your bitcoin data will be stored.
$ mkdir /home/youruser/bitcoin_data

$ docker build --no-cache -t bitcoind:latest .
$ docker run --name bitcoind -d \
   --env 'BTC_RPCUSER=foo' \
   --env 'BTC_RPCPASSWORD=password' \
   --env 'BTC_TXINDEX=1' \
   --env 'BTC_TESTNET=1' \
   --env 'BTC_DBCACHE=3000' \ # Set the cache size in Mb for faster sync times
   --env 'BTC_RUN_ARGS="-reindex"' \  # Forwarded on to the bitcoind call.
   --volume /home/youruser/bitcoin_data:/bitcoin \
   -p 18332:18332
   --publish 18333:18333
   bitcoind

$ docker logs -f bitcoind
[ ... ]
```


## Configuration

A custom `bitcoin.conf` file can be placed in the mounted data directory.
Otherwise, a default `bitcoin.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| BTC_RPCUSER | btc |
| BTC_RPCPASSWORD | changemeplz |
| BTC_RPCPORT | 8332 |
| BTC_RPCALLOWIP | ::/0 |
| BTC_RPCCLIENTTIMEOUT | 30 |
| BTC_DISABLEWALLET | 1 |
| BTC_TXINDEX | 0 |
| BTC_DBCACHE | 1000 |
| BTC_TESTNET | 0 |


## Daemonizing

If you're using systemd, you can use a config file like

```
$ cat /etc/systemd/system/bitcoind.service

# bitcoind.service #######################################################################
[Unit]
Description=Bitcoind
After=docker.service
Requires=docker.service

[Service]
ExecStartPre=-/usr/bin/docker kill bitcoind
ExecStartPre=-/usr/bin/docker rm bitcoind
ExecStart=/usr/bin/docker run \
    --name bitcoind \
    -p 18333:18333 \
    -p 18332:18332 \
    -v /data/bitcoind:/bitcoin \
    bitcoind
ExecStop=/usr/bin/docker stop bitcoind
```

to ensure that bitcoind continues to run.


## Alternatives

- [docker-bitcoind](https://github.com/kylemanna/docker-bitcoind): sort of the
  basis for this repo, but configuration is a bit more confusing.
- [docker-bitcoin](https://github.com/amacneil/docker-bitcoin): more complex, but
  more granular versioning. Includes XT & classic.
