use starknet::ContractAddress;

#[derive(Drop, Serde, starknet::Store)]
pub struct ReceivedTx {
    pub tx_id: u256,
    pub tx_status: u8,
    pub from_chain: felt252,
    pub to_chain: felt252,
    pub from_handler: u256,
    pub to_handler: ContractAddress
}

#[derive(Drop, Serde, starknet::Store)]
pub struct CreatedTx {
    pub tx_id: felt252,
    pub tx_status: u8,
    pub from_chain: felt252,
    pub to_chain: felt252,
    pub from_handler: ContractAddress,
    pub to_handler: u256
}

#[starknet::interface]
pub trait IERC20Mint<TContractState> {
    fn mint(ref self: TContractState, amount: u256);
    fn mint_to(ref self: TContractState, account: ContractAddress, amount: u256);
    fn burn_from(ref self: TContractState, account: ContractAddress, amount: u256);
}

#[starknet::interface]
pub trait IERC20<TContractState> {
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(ref self: TContractState, from: ContractAddress, to: ContractAddress, amount: u256) -> bool;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn balance_of(self: @TContractState, address: ContractAddress) -> u256;
    fn burn(ref self: TContractState, account: ContractAddress, amount: u256);
}

#[starknet::interface]
pub trait IERC20Handler<TContractState> {
    fn receive_cross_chain_msg(ref self: TContractState, cross_chain_msg_id: u256, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, payload: Array<u8>) -> bool;
    fn receive_cross_chain_callback(ref self: TContractState, cross_chain_msg_id: felt252, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, cross_chain_msg_status: u8) -> bool;
    fn cross_chain_erc20_settlement(ref self: TContractState, to_chain: felt252, to_handler: u256, to_token: u256, to: u256, amount: u256) -> felt252;
    fn is_valid_handler(self: @TContractState, chain_name: felt252, handler: u256) -> bool;
    fn set_support_handler(ref self:TContractState, chain_name: felt252, handler: u256, support: bool);
    fn upgrade_settlement(ref self:TContractState, new_settlement: ContractAddress);
    fn view_settlement(self: @TContractState) -> ContractAddress;
    fn mode(self: @TContractState) -> u8;
}

#[starknet::interface]
pub trait IHandler<TContractState> {
    fn receive_cross_chain_msg(ref self: TContractState, cross_chain_msg_id: u256, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, payload: Array<u8>) -> bool;
    fn receive_cross_chain_callback(ref self: TContractState, cross_chain_msg_id: felt252, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, cross_chain_msg_status: u8) -> bool;
    fn send_cross_chain_msg(ref self: TContractState, to_chain: felt252, to_handler: u256, payload: Array<u8>)-> felt252;
}

#[starknet::interface]
pub trait IChakraSettlement<TContractState> {

    fn add_validator(ref self: TContractState, new_validator: felt252) -> bool;
    fn remove_validator(ref self: TContractState, old_validator: felt252) -> bool;
    fn is_validator(self: @TContractState, validator: felt252) -> bool;
    fn add_manager(ref self: TContractState, new_manager: ContractAddress) -> bool;
    fn remove_manager(ref self: TContractState, old_manager: ContractAddress) -> bool;
    fn is_manager(self: @TContractState, manager: ContractAddress) -> bool;

    fn set_required_validators_num(ref self: TContractState, new_num: u32) -> u32;
    fn view_required_validators_num(self: @TContractState) -> u32;

    fn send_cross_chain_msg(
        ref self: TContractState, to_chain: felt252, to_handler: u256, payload_type :u8, payload: Array<u8>,
    ) -> felt252;

    fn receive_cross_chain_msg(
        ref self: TContractState,
        cross_chain_msg_id: u256,
        from_chain: felt252,
        to_chain: felt252,
        from_handler: u256,
        to_handler: ContractAddress,
        sign_type: u8,
        signatures: Array<(felt252, felt252, bool)>,
        payload: Array<u8>,
        payload_type: u8
    ) -> bool;

    fn receive_cross_chain_callback(
        ref self: TContractState,
        cross_chain_msg_id: felt252,
        from_chain: felt252,
        to_chain: felt252,
        from_handler: u256,
        to_handler: ContractAddress,
        cross_chain_msg_status: u8,
        sign_type: u8,
        signatures: Array<(felt252, felt252, bool)>,
    ) -> bool;

    fn message_hash_receive(self: @TContractState, cross_chain_msg_id: u256, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, payload: Array<u8>) -> felt252;
    fn message_hash_callback(self: @TContractState, cross_chain_msg_id: felt252, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, cross_chain_msg_status: u8) -> felt252;

    fn get_recevied_tx(self: @TContractState, tx_id: u256) -> ReceivedTx;

    fn get_created_tx(self: @TContractState, tx_id: felt252) -> CreatedTx;
    
    fn set_chain_name(ref self: TContractState, chain_name: felt252);

    fn chain_name(self: @TContractState) -> felt252;

    
}