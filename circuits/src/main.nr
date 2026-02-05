use dep::std;

fn main(
    secret: Field, 
    nullifier_seed: Field, 
    public_id: pub Field, 
    root: pub Field,
    nullifier_hash: pub Field
) {
    let computed_nullifier = std::hash::pedersen_hash([secret, nullifier_seed]);

    // Final constraint: The provided hash MUST match the computed one
    assert(computed_nullifier == nullifier_hash); 

    let commitment = std::hash::pedersen_hash([secret, public_id]);
    assert(commitment != 0);
    assert(root != 0); 
}