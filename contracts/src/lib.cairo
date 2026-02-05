pub mod verifier;

#[starknet::interface]
pub trait IVortexVault<TContractState> {
    fn deposit_btc(ref self: TContractState, amount: u256);
    fn withdraw_private(
        ref self: TContractState, 
        proof: Span<felt252>, 
        nullifier: felt252, 
        amount: u256
    );
}

#[starknet::contract]
mod VortexVault {
    use starknet::ContractAddress;
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, 
        Map, StoragePathEntry // Added StoragePathEntry for modern Map access
    };
    
    // Import the interface for our verifier
    use super::verifier::{IPrivateVerifierDispatcher, IPrivateVerifierDispatcherTrait};

    #[storage]
    struct Storage {
        total_btc: u256,
        verifier_addr: ContractAddress,
        // The 'Nullifier' prevents the same ZK-proof from being used twice
        used_nullifiers: Map<felt252, bool>, 
    }

    #[constructor]
    fn constructor(ref self: ContractState, verifier_address: ContractAddress) {
        self.verifier_addr.write(verifier_address);
    }

    #[abi(embed_v0)]
    impl VortexVaultImpl of super::IVortexVault<ContractState> {
        fn deposit_btc(ref self: ContractState, amount: u256) {
            let current = self.total_btc.read();
            self.total_btc.write(current + amount);
        }

        fn withdraw_private(
            ref self: ContractState, 
            proof: Span<felt252>, 
            nullifier: felt252, 
            amount: u256
        ) {
            let verifier = IPrivateVerifierDispatcher { 
                contract_address: self.verifier_addr.read() 
            };
            
            // 1. Verify the Proof (Public input is the nullifier)
            let mut public_inputs = array![nullifier];
            assert(
                verifier.verify_proof(proof, public_inputs.span()), 
                'Invalid ZK Proof'
            );

            // 2. Double-Spending Protection
            // Using .entry() to access the Map key
            let is_spent = self.used_nullifiers.entry(nullifier).read();
            assert(!is_spent, 'Nullifier already spent');
            self.used_nullifiers.entry(nullifier).write(true);

            // 3. Subtract from Vault Total
            let current = self.total_btc.read();
            assert(current >= amount, 'Insufficient vault funds');
            self.total_btc.write(current - amount);
        }
    }
}