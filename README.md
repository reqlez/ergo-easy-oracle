# Easy Ergo Node + Oracle Setup

Prerequisites: make sure git, nano?, docker, and docker compose plugin are installed.
For Docker, follow: https://docs.docker.com/engine/install/  +  https://docs.docker.com/engine/install/linux-postinstall/

Clone this repo:

```console
git clone https://github.com/reqlez/ergo-easy-oracle.git && cd ergo-easy-oracle
```

Clone oracle-core repo ( OPTIONAL - only if building instead of using DockerHub image ):

```console
git clone -b develop https://github.com/ergoplatform/oracle-core.git
```

Create Docker network and set folder permissions with container UIDs:

```console
docker network create ergo-node
```

```console
sudo chown -R 9052:9052 node_data && sudo chown -R 9010:9010 oracle_data
```

Copy example .env file and edit:
( Replace CHANGE_ME_KEY with the same NEW api key as YOUR_API_KEY two steps from now ):

```console
cp .env.example .env
nano .env
```

Build + start node container temporarily to generate API Key Hash:

```console
docker compose build --no-cache
docker compose up --no-start
docker compose start node
```

Generate an 'apiKeyHash' for node, ex:

```console
curl -X POST "http://localhost:9053/utils/hash/blake2b" -H "Content-Type: application/json" -d "\"YOUR_API_KEY\""
```

Stop node container:

```console
docker compose stop node
```

Uncomment / set settings like apiKeyHash:

- `sudo nano node_data/ergo.conf`

Start node and initialize wallet - IMPORTANT: make sure to store the mnemonic phrase output in a safe place:

```console
docker compose start node
```

```console
curl -X POST "http://localhost:9053/wallet/init" -H "api_key: YOUR_API_KEY" -H "Content-Type: application/json" -d "{\"pass\":\"YOUR_WALLET_PASS\"}"
```

Get wallet address so you can set it under 'oracle_address' in oracle config yaml

```console
curl -X GET "http://localhost:9053/wallet/addresses" -H "api_key: YOUR_API_KEY"
```

Add some ERG for your wallet address above.

Set oracle_address to the address from previous step:

- `sudo nano oracle_data/oracle_config.yaml`

Wait for node to sync, you can monitor progress under: http://ip.of.your.node:9053/panel

```console
docker compose down
```
```console
docker compose up -d
```

Please note that you will need the oracle tokens sent to that address as well ( oracle_address ).
Keep the wallet unlocked, for the oracle to be operational.

For troubleshooting, check combined logs via:

```console
docker compose logs -f
```

Or individual logs, via:

```console
docker compose logs -f node
docker compose logs -f core
docker compose logs -f prometheus
docker compose logs -f grafana
```

You may also have to restart the oracle, after unlocking wallet, for example:

```console
docker compose restart core
```
However, the auto-restart process should be able to handle that condition.

If you wish to set a cron task to extract tokens you can use below command with 'crontab -e' ex:

```console
@weekly docker compose -f /path/to/ergo-easy-oracle/docker-compose.yml exec -it core /bin/sh -c 'yes YES | oracle-core --oracle-config-file /data/oracle_config.yaml --pool-config-file /data/pool_config.yaml -d /data extract-reward-tokens ADDRESS_TO_EXTRACT_TO_HERE'
```
