#!/bin/bash

# Install Noir (Nargo)
curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
export PATH="$HOME/.nargo/bin:$PATH"
noirup -v 1.0.0-beta.18

# Install Scarb (Cairo/Starknet package manager)
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh

# Install Starknet Foundry (Sncast)
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | bash
export PATH="$HOME/.starknet-foundry/bin:$PATH"
snfoundryup

echo "Environment Ready! Vortex Vaults is ready for inspection."