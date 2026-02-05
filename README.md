# Vortex Vaults
> **Quantum-safe, ZK-shielded liquidity for the Bitcoin-Starknet era.**

## Live on Starknet Sepolia
- **Contract Address:** [0x052422ead523b8a4647b240aa63b00fcfb6c6a45a2799d4b31aa6ea41e955e10](https://sepolia.voyager.online/contract/0x052422ead523b8a4647b240aa63b00fcfb6c6a45a2799d4b31aa6ea41e955e10)
- **Verified Source Code:** [View on Voyager](https://sepolia.voyager.online/contract/0x052422ead523b8a4647b240aa63b00fcfb6c6a45a2799d4b31aa6ea41e955e10)
---

## The Vision
**The Problem:** In 2026, privacy is the primary institutional hurdle for Bitcoin DeFi. Every bridge transaction currently doxxes a user's financial history by linking public UTXOs to public L2 addresses.

**The Solution:** Vortex Vaults solves the "privacy-liquidity trilemma" by combining **Bitcoin security**, **Noir’s ZK-precision**, and **Starknet’s scalability**. Our architecture ensures that while assets are verified on-chain, the link between the depositor and the withdrawer is cryptographically erased.

## Competitive Advantage: Why Vortex Wins

| Feature | Standard Bridge | Traditional Mixer | **Vortex Vaults** |
| :--- | :--- | :--- | :--- |
| **User Privacy** | ❌ Public Link | ⚠️ Centralized Risk | ✅ **ZK-Shielded (Noir)** |
| **Trust Model** | ✅ Trustless | ❌ High Trust | ✅ **Trust-minimized** |
| **Regulatory Fit** | ❌ Fully Public | ❌ Often Sanctioned | ✅ **ZK-Identity Compatible** |
| **Auditability** | ✅ Yes | ❌ No | ✅ **ZK-Provable** |

---

##  Technical Implementation

### 1. Zero-Knowledge Architecture (Noir)
Our privacy layer is powered by a Noir circuit utilizing a **Deterministic Nullifier** pattern—the same logic used by industry leaders like Aztec to provide "Shielded" transactions.

* **The "Secret" Mechanism:** A user generates a private `secret` and a `nullifier_seed` locally.
* **Pedersen Hashing:** Optimized for ZK-SNARKs, this derives a public `nullifier_hash`. Because it is deterministic, double-spending is impossible, yet the protocol cannot trace the hash back to the original deposit.
* **Identity Linking:** The circuit bridges the private secret to a `public_id` (Starknet recipient). This ensures funds are only released to the intended recipient even if a proof is intercepted.
* **Circuit Soundness:** Strict `assert` constraints in Noir guarantee that if a single bit is changed (fake secret or wrong address), the proof fails.

### 2. Smart Contract Layer (Cairo 2.x)
The Starknet contracts serve as the "On-Chain Judge," verifying the math without seeing the secrets.

* **VortexVault.cairo:** Tracks used `nullifier_hashes` in a persistent Map. It verifies the ZK-proof before releasing BTC-equivalent assets.
* **Verifier.cairo:** A specialized contract designed to verify Noir’s **UltraHonk** proofs, performing complex elliptic curve pairings in a gas-efficient manner.

### 3. Atomiq Bridge Integration (Conceptual)
By utilizing the **Atomiq SDK**, we allow users to move native BTC into the Vortex Vault. Once "Vortexed" on Starknet, the value moves privately across the L2 ecosystem, eventually exiting back to Bitcoin without a traceable on-chain trail.

---

##  Roadmap: Beyond the Hackathon
* **Q2 2026:** **Recursive Proofs** – Implementing proof aggregation to reduce withdrawal gas costs by up to 90%.
* **Q3 2026:** **Atomiq SDK Deep Integration** – Enabling one-click native BTC ↔ Shielded Starknet liquidity swaps.
* **Q4 2026:** **L3 Privacy Layer** – Launching a dedicated AppChain for ultra-low-cost confidential transactions and private DeFi primitives.

---

## This project is fully containerized. You can run the entire Vortex Vault suite (Cairo, Noir, and Starknet Foundry) without installing any local dependencies.

### GitHub Codespaces (Recommended)
1. Click the **Code** button on this repo.
2. Select the **Codespaces** tab and click **Create codespace on main**.
3. Wait ~60 seconds for the container to build. All tools (`scarb`, `sncast`, `nargo`) are pre-configured.

##  How to Verify Locally
Our environment is fully containerized. To verify the cryptographic integrity:

1. **Enter the Circuit Directory:**
   ```bash
   cd circuits
2.
   ```bash
   nargo execute vortex_proof
Validation: Observe the terminal output: [circuits] Circuit witness successfully solved.
