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

    fn get_recevied_tx(self: @TContractState, tx_id: u256) -> ReceivedTx;

    fn get_created_tx(self: @TContractState, tx_id: felt252) -> CreatedTx;
    
    fn set_chain_name(ref self: TContractState, chain_name: felt252);

    fn chain_name(self: @TContractState) -> felt252;

    
}