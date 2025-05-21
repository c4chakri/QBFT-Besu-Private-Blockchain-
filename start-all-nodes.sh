#!/usr/bin/env bash
set -euo pipefail

BASE_IP="192.168.1."
BOOTNODE_ENODE="enode://b47663d5fed91287abeb711690fcc5c249aaddcf49eb71fb71e5a5b309b54a52947459beae1e368b5d4b3931eae28e686f7be9f567286fb2a544c5b5fcc9e1fb@${BASE_IP}2:30303"

for i in 1 2 3 4; do
  P2P_PORT=$((30300 + i))
  RPC_PORT=$((8544 + i))
  METRICS_PORT=$((9544 + i))
  DATA_DIR="/besu/Node-${i}/data"

  CMD_ARGS=(
    "--data-path=${DATA_DIR}"
    "--genesis-file=/besu/genesis.json"
    "--p2p-port=${P2P_PORT}"
    "--rpc-http-enabled"
    "--rpc-http-port=${RPC_PORT}"
    "--rpc-http-api=ETH,NET,QBFT,WEB3"
    "--host-allowlist=*"
    "--rpc-http-cors-origins=all"
    "--profile=ENTERPRISE"
    "--min-gas-price=1000"
    "--version-compatibility-protection=false"
    "--metrics-enabled"
    "--metrics-host=0.0.0.0"
    "--metrics-port=${METRICS_PORT}"
  )

  # nodes 2–4 need the bootnode flag
  if [[ $i -ne 1 ]]; then
    CMD_ARGS+=( "--bootnodes=${BOOTNODE_ENODE}" )
  fi

  echo "Starting besu-node-${i} on RPC=${RPC_PORT}, P2P=${P2P_PORT}, METRICS=${METRICS_PORT}"
  besu "${CMD_ARGS[@]}" &
done

wait
