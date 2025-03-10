# Use the official Hyperledger Besu image
FROM hyperledger/besu:latest

# Set the working directory
WORKDIR /besu

# Copy the genesis file and network configurations
COPY genesis.json /besu/genesis.json
COPY qbftConfigFile.json /besu/qbftConfigFile.json
COPY networkFiles /besu/networkFiles

# Copy node data directories
COPY Node-1 /besu/Node-1
COPY Node-2 /besu/Node-2
COPY Node-3 /besu/Node-3
COPY Node-4 /besu/Node-4

# Expose required ports
EXPOSE 30303 8545 8546 8547

# Define the default command for the container
CMD ["besu", "--data-path=/besu/Node-1/data", \
     "--genesis-file=/besu/genesis.json", \
     "--config-file=/besu/qbftConfigFile.json", \
     "--rpc-http-enabled", \
     "--rpc-http-api=ETH,NET,QBFT,WEB3", \
     "--host-allowlist=*"]
