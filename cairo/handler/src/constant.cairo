pub mod PayloadType{
    pub const Raw: u8 = 0;
    pub const BTCDeposit: u8 = 1;
    pub const BTCWithdraw: u8 = 2;
    pub const BTCStake: u8 = 3;
    pub const BTCUnstake: u8 = 4;
    pub const ERC20: u8 = 5;
    pub const ERC721: u8 = 6;
}

pub mod SettlementMode{
    pub const MintBurn: u8 = 0;
    pub const LockMint: u8 = 1;
    pub const BurnUnlock: u8 = 2;
    pub const LockUnlock: u8 = 3;
}

pub mod TxStatus {
    pub const UNKNOW: u8 = 0;
    pub const PENDING: u8 = 1;
    pub const MINTED: u8 = 2;
    pub const BURNED: u8 = 3;
    pub const FAILED: u8 = 4;
}

pub mod ERC20Method {
    pub const UNKNOW: u8 = 0;
    pub const TRANSFER: u8 = 1;
    pub const APPROVE: u8 = 2;
    pub const TRANSFERFROM: u8 = 3;
    pub const MINT: u8 = 4;
    pub const BURN: u8 = 5;
}

pub mod CrossChainTxStatus{
    pub const UNKNOW: u8 = 0;
    pub const PENDING: u8 = 1;
    pub const MINTED: u8 = 2;
    pub const SETTLED: u8 = 3;
    pub const FAILED: u8 = 4;
}