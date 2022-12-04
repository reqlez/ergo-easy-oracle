# Easy Ergo Node + Oracle Setup

Prerequisites: make sure git, nano?, docker, and docker compose plugin are installed.

Clone this repo:

```console
git clone https://github.com/reqlez/tn-ergo-easy-oracle.git && cd tn-ergo-easy-oracle
```

Clone oracle-core repo:

```console
git clone -b develop https://github.com/ergoplatform/oracle-core.git
```

Create Docker network / volume:

```console
docker network create tn-ergo-node
```

```console
docker volume create tn_ergo_node
```

Build/Start containers temporarily to generate API Key Hash:

```console
docker compose up -d --build
```

Generate an 'apiKeyHash' for node, ex:

```console
curl -X POST "http://localhost:9052/utils/hash/blake2b" -H "Content-Type: application/json" -d "\"YOUR_API_KEY\""
```

Stop containers:

```console
docker compose down
```

Uncomment / set settings like apiKeyHash + node_api_key:

- `config/ergo.conf`
- `config/oracle_config.yaml`

Start containers and initialize wallet:

```console
docker compose up -d
```

```console
curl -X POST "http://localhost:9052/wallet/init" -H "api_key: YOUR_API_KEY" -H "Content-Type: application/json" -d "{\"pass\":\"YOUR_WALLET_PASS\"}"
```

Get wallet address so you can set it under 'oracle_address' in oracle config yaml

```console
curl -X GET "http://localhost:9052/wallet/addresses" -H "api_key: YOUR_API_KEY"
```

Visit https://tn-faucet.ergohost.io and get some test ERG for your address.

After setting 'oracle_address' in oracle config yaml, restart containers.

```console
docker compose down
```
```console
docker compose up -d
```

Please note that you will need the oracle tokens sent to that address as well before it will operate.

For troubleshooting, check combined node + oracle logs via:

```console
docker compose logs -f
```
