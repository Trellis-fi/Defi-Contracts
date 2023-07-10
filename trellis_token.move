module trellis_token::trellis_token {
    use std::signer;
    use std::string;
    use aptos_framework::managed_coin;
    use aptos_framework::coin;

    struct TrellisToken {}
    const MODULE_OWNER: address = @trellis_token;
    const INVALID_ADMIN: u64 = 1;

    
    const DECIMAL: u8 = 6;
    
    const SUPPLY: u64 = 100000000 * 1000000;

    public entry fun init_token(
        admin: &signer	
    ){
        let admin_addr = signer::address_of(admin);
        assert!(admin_addr == MODULE_OWNER, INVALID_ADMIN);

         let (burn_cap, freeze_cap, mint_cap) = coin::initialize<TrellisToken>(
            admin,
            string::utf8(b"Trellis Token"),
            string::utf8(b"TRELLIS"),
            DECIMAL,
            true,
        );

        let coins_minted = coin::mint(SUPPLY, &mint_cap);

        coin::destroy_mint_cap<TrellisToken>(mint_cap);
        coin::destroy_burn_cap<TrellisToken>(burn_cap);
        coin::destroy_freeze_cap<TrellisToken>(freeze_cap);

        if(!coin::is_account_registered<TrellisToken>(admin_addr)){
            managed_coin::register<TrellisToken>(admin);
        };

        coin::deposit(admin_addr, coins_minted);
    }
}
