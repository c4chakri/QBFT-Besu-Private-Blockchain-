# Use the official Hyperledger Besu image
FROM hyperledger/besu:latest

# Set the working directory inside the container
WORKDIR /besu

# Copy the genesis file, QBFT config, and static networking files
COPY genesis.json        /besu/genesis.json
COPY qbftConfigFile.json /besu/qbftConfigFile.json
COPY networkFiles        /besu/networkFiles

# Copy pre-initialized node data directories (optional—you may also mount these at runtime)
COPY Node-1 /besu/Node-1
COPY Node-2 /besu/Node-2
COPY Node-3 /besu/Node-3
COPY Node-4 /besu/Node-4

# Expose P2P, RPC and metrics ports for all four nodes
EXPOSE 30303 30304 30305 30306
EXPOSE 8545 8546 8547 8548
EXPOSE 9545 9546 9547 9548

# Entrypoint wraps the besu binary
ENTRYPOINT ["besu"]

# Default to running Node-1; override at docker run / service definition
CMD [
  "--data-path=/besu/Node-1/data",
  "--genesis-file=/besu/genesis.json",
  "--config-file=/besu/qbftConfigFile.json",
  "--rpc-http-enabled",
  "--rpc-http-api=ETH,NET,QBFT,WEB3",
  "--host-allowlist=*",
  "--rpc-http-cors-origins=all",
  "--profile=ENTERPRISE",
  "--min-gas-price=1000",
  "--version-compatibility-protection=false",
  "--metrics-enabled",
  "--metrics-host=0.0.0.0",
  "--metrics-port=9545"
]
