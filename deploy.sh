#!/bin/bash

# 1. Declare and Deploy the Verifier first
echo "Deploying PrivateVerifier..."
VERIFIER_RES=$(sncast deploy --contract-name PrivateVerifier)
VERIFIER_ADDR=$(echo $VERIFIER_RES | grep -oE "0x[0-9a-fA-F]+")

echo "Verifier Address: $VERIFIER_ADDR"

# 2. Deploy the Vault, passing the Verifier Address to the constructor
echo "Deploying VortexVault..."
VAULT_RES=$(sncast deploy --contract-name VortexVault --constructor-calldata $VERIFIER_ADDR)
VAULT_ADDR=$(echo $VAULT_RES | grep -oE "0x[0-9a-fA-F]+")

echo "Vault Address: $VAULT_ADDR"