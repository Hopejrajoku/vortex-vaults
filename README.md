# Vortex Vaults: Technical Implementation
Vortex Vaults solves the "privacy-liquidity trilemma" by combining Bitcoin security, Noir’s ZK-precision, and Starknet’s scalability. Our architecture ensures that while the assets are verified on-chain, the link between the depositor and the withdrawer is cryptographically erased.

## 1. Zero-Knowledge Architecture (Noir)
Our privacy layer is powered by a Noir circuit utilizing a Deterministic Nullifier pattern. This is the same logic used by industry leaders like Aztec to provide "Shielded" transactions.

The "Secret" Mechanism: A user generates a private secret and a nullifier_seed. These never leave the user's local machine.

Pedersen Hashing: The circuit uses the Pedersen hash function—optimized for ZK-snarks—to derive a public nullifier_hash. Because this hash is deterministic, the user can only spend their deposit once, but the protocol cannot trace the hash back to the original deposit.

Identity Linking: The circuit bridges the private secret to a public_id (the Starknet recipient address). This ensures that even if a proof were intercepted, the funds could only be released to the intended recipient.

Circuit Soundness: The assert constraints in Noir guarantee that if a single bit of the input is changed (e.g., trying to withdraw to a different address or using a fake secret), the proof will fail to generate.

## 2. Smart Contract Layer (Cairo 2.x)
The Starknet contracts serve as the "On-Chain Judge." They don't need to know your secrets; they only need to see the math check out.

VortexVault.cairo: This is the heart of the vault. It tracks used nullifier_hashes in a persistent Map. When a withdrawal is requested, the contract checks if the nullifier has been seen before. If not, it verifies the ZK-proof and releases the BTC-equivalent assets.

Verifier.cairo: A specialized contract designed to verify Noir’s UltraHonk proofs. It performs the complex elliptic curve pairings required to "greenlight" a proof on-chain in a gas-efficient manner.

## 3. Atomiq Bridge Integration (Conceptual)
Vortex acts as the "Private Extension" for Bitcoin. By utilizing the Atomiq SDK, we allow users to move native BTC into the Vortex Vault. Once the BTC is "Vortexed" on Starknet, the user can move value privately across the L2 ecosystem, eventually exiting back to Bitcoin without a traceable on-chain trail.

How to Verify Locally
Our environment is fully containerized. To verify the cryptographic integrity of the system:

Enter the Circuit Directory:

Bash
``cd circuits``
Generate the Witness: Run the execution engine to solve the circuit constraints:

Bash
``nargo execute vortex_proof``
Validation: Observe the terminal output: [circuits] Circuit witness successfully solved.

Note: This confirms that the test vectors in Prover.toml satisfy every mathematical constraint in the circuit. The generated witness file in target/ is the basis for the final ZK-proof.

## Feature,Standard Bridge,Traditional Mixer,Vortex Vaults
Privacy,❌ None (Public),⚠️ Centralized/Custodial,✅ ZK-Shielded (Noir)
Bitcoin Security,✅ Native,❌ High Trust Required,✅ Trust-minimized
L2 Performance,✅ Fast,❌ Slow/Manual,✅ Starknet Native
Auditability,✅ Public,❌ Black Box,✅ Math-Provable
