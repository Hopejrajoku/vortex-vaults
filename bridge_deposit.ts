import { AtomiqSDK, Network } from '@atomiq/sdk';
import { Account, RpcProvider, Contract } from 'starknet';

async function initiateVortexDeposit(amountSats: number, userStarknetAddress: string) {
    // 1. Initialize Atomiq (Bitcoin Side)
    const sdk = new AtomiqSDK({
        network: Network.TESTNET, // Use Bitcoin Testnet4/Signet
        apiKey: process.env.ATOMIQ_API_KEY
    });

    // 2. Define the Starknet Vault target
    const VORTEX_VAULT_ADDRESS = "0x0...your_vault_address";
    
    console.log(`🌀 Initiating Vortex Deposit for ${amountSats} sats...`);

    // 3. Create the Bitcoin Lock
    // This generates a Bitcoin address for the user to send funds to.
    const lockRequest = await sdk.btc.createLock({
        amount: amountSats,
        recipientAddress: VORTEX_VAULT_ADDRESS,
        metadata: {
            starknet_recipient: userStarknetAddress,
            action: "VORTEX_DEPOSIT"
        }
    });

    console.log(`✅ Bitcoin Lock Created!`);
    console.log(`👉 Send ${amountSats} sats to: ${lockRequest.depositAddress}`);

    // 4. Listen for the Lock Confirmation
    // Once Bitcoin miners confirm the tx, Atomiq triggers the Starknet side.
    lockRequest.on('confirmed', async (txHash) => {
        console.log(`🚀 Bitcoin Tx Confirmed: ${txHash}`);
        console.log(`🔗 Starknet VortexVault.deposit_btc() is being triggered...`);
    });
}