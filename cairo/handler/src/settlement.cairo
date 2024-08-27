use starknet::ContractAddress;

#[starknet::contract]
mod ChakraSettlement {
    use core::array::SpanTrait;
    use core::option::OptionTrait;
    use core::array::ArrayTrait;
    use core::traits::Into;
    use core::ecdsa::{recover_public_key};
    use core::box::BoxTrait;
    use core::num::traits::Zero;
    use core::hash::LegacyHash;
    use core::starknet::event::EventEmitter;
    use starknet::ClassHash;
    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_tx_info, get_block_timestamp};
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use openzeppelin::access::ownable::interface::OwnableABI;
    use settlement_cairo::interfaces::{IHandlerDispatcher, IHandlerDispatcherTrait,IChakraSettlement, ReceivedTx, CreatedTx};
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

    // The status of Cross Chain Message Status
    pub mod CrossChainMsgStatus {
        pub const UNKNOW: u8 = 0;
        pub const PENDING: u8 = 1;
        pub const SUCCESS: u8 = 2;
        pub const FAILED: u8 = 3;
    }


    // The type of Cross Chain Message Payload
    pub mod CrossChainMsgPayloadType {
        pub const RAW: u8 = 0;
        pub const BTCDeposit: u8 = 1;
        pub const BTCStake: u8 = 2;
        pub const BTCUnStake: u8 = 3;
        pub const ERC20: u8 = 4;
        pub const ERC721: u8 = 5;
    }

    // Ownable Mixin
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // Upgradeable
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
        // storage the pubkeys as validator
        chakra_validators_pubkey: LegacyMap<felt252, u8>,
        // storage manager
        chakra_managers: LegacyMap<ContractAddress, u8>,
        // storage the txs which received
        received_tx:LegacyMap<u256, ReceivedTx>,
        // storage the txs which created
        created_tx:LegacyMap<felt252, CreatedTx>,
        // deployed chain name
        chain_name:felt252,
        // the number of verified signature
        required_validators_num: u32,
        // transaction count
        tx_count: u256
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
        ManagerAdded: ManagerAdded,
        ManagerRemoved: ManagerRemoved,
        ValidatorAdded: ValidatorAdded,
        ValidatorRemoved: ValidatorRemoved,
        CrossChainMsg: CrossChainMsg,
        CrossChainHandleResult: CrossChainHandleResult,
        CrossChainResult: CrossChainResult
    }


    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct CrossChainMsg {
        #[key]
        pub cross_chain_settlement_id: felt252,
        #[key]
        pub from_address: ContractAddress,
        pub from_chain: felt252,
        pub from_handler: ContractAddress,
        pub to_chain: felt252,
        pub to_handler: u256,
        pub payload_type: u8,
        pub payload: Array<u8>
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct CrossChainHandleResult {
        #[key]
        pub cross_chain_settlement_id: u256,
        pub from_chain: felt252,
        pub from_handler: ContractAddress,
        pub to_chain: felt252,
        pub to_handler: u256,
        pub cross_chain_msg_status: u8,
        pub payload_type: u8,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct CrossChainResult {
        #[key]
        pub cross_chain_settlement_id: felt252,
        pub from_address: ContractAddress,
        pub from_chain: felt252,
        pub from_handler: ContractAddress,
        pub to_chain: felt252,
        pub to_handler: u256,
        pub cross_chain_msg_status: u8,
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct ManagerAdded {
        #[key]
        pub operator: ContractAddress,
        pub new_manager: ContractAddress,
        pub added_at: u64
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct ManagerRemoved {
        #[key]
        pub operator: ContractAddress,
        pub old_manager: ContractAddress,
        pub removed_at: u64
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct ValidatorAdded {
        #[key]
        pub operator: ContractAddress,
        pub new_validator: felt252,
        pub added_at: u64
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct ValidatorRemoved {
        #[key]
        pub operator: ContractAddress,
        pub old_validator: felt252,
        pub removed_at: u64
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress, chain_name: felt252) {
        self.ownable.initializer(owner);
        self.chakra_managers.write(owner, 1);
        self.chain_name.write(chain_name);
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        // validate signatures should > required_validators_num
        // @param message_hash the perdsen hash of message 
        // @param the signatures corresponding to each verifier
        fn check_chakra_signatures(
            self: @ContractState, message_hash: felt252, signatures: Array<(felt252, felt252, bool)>
        ){
            let mut pass_count = 0;
            let mut i = 0;
            loop {
                if i > signatures.len()-1{
                    break;
                }
                let (r,s,y) = * signatures.at(i);
                let pub_key: felt252 = recover_public_key(message_hash,r,s,y).unwrap();
                if self.chakra_validators_pubkey.read(pub_key) > 0{
                    pass_count += 1;
                }
                i += 1;
            };
            assert(pass_count >= self.required_validators_num.read(), 'Not enough validate signatures');
        }
    }

    #[abi(embed_v0)]
    impl ChakraSettlementImpl of IChakraSettlement<ContractState> {
        // @notice change the number of reqire validators, only manager can call this function
        // @param new_num the number of reqire validators
        fn set_required_validators_num(ref self: ContractState, new_num: u32) -> u32 {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, 'Caller is not a manager');
            self.required_validators_num.write(new_num);
            return self.required_validators_num.read();
        }

        fn view_required_validators_num(self: @ContractState) -> u32 {
            return self.required_validators_num.read();
        }

        // Validators related operations
        fn add_validator(ref self: ContractState, new_validator: felt252) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, 'Caller is not a manager');
            assert(self.chakra_validators_pubkey.read(new_validator) == 0, 'Caller is a validator already');
            self.chakra_validators_pubkey.write(new_validator, 1);
            self
                .emit(
                    ValidatorAdded {
                        operator: caller,
                        new_validator: new_validator,
                        added_at: get_block_timestamp()
                    }
                );
            return self.chakra_validators_pubkey.read(new_validator) == 1;
        }
        
        fn remove_validator(ref self: ContractState, old_validator: felt252) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, 'Caller is not a manager');
            assert(self.chakra_validators_pubkey.read(old_validator) == 1, 'Caller is not a validator');
            self.chakra_validators_pubkey.write(old_validator, 0);
            self
                .emit(
                    ValidatorRemoved {
                        operator: caller,
                        old_validator: old_validator,
                        removed_at: get_block_timestamp()
                    }
                );
            return self.chakra_validators_pubkey.read(old_validator) == 0;
        }

        fn is_validator(self: @ContractState, validator: felt252) -> bool {
            return self.chakra_validators_pubkey.read(validator) == 1;
        }

        // Managers related operations
        fn add_manager(ref self: ContractState, new_manager: ContractAddress) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, 'Caller is not a manager');
            assert(caller != new_manager, 'Caller is a manager already');
            self.chakra_managers.write(new_manager, 1);
            self
                .emit(
                    ManagerAdded {
                        operator: caller, new_manager: new_manager, added_at: get_block_timestamp()
                    }
                );
            return self.chakra_managers.read(new_manager) == 1;
        }

        fn remove_manager(ref self: ContractState, old_manager: ContractAddress) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, 'Caller is not a manager');
            self.chakra_managers.write(old_manager, 0);
            self
                .emit(
                    ManagerRemoved {
                        operator: caller,
                        old_manager: old_manager,
                        removed_at: get_block_timestamp()
                    }
                );
            return self.chakra_managers.read(old_manager) == 0;
        }

        fn is_manager(self: @ContractState, manager: ContractAddress) -> bool {
            return self.chakra_managers.read(manager) == 1;
        }

        // @notice send cross chain message, only handler can call this function
        // @param to_chain cross message to chain
        // @param to_handler cross message to handler
        // @param payload_type message payload type
        // @param payload message content
        fn send_cross_chain_msg(
            ref self: ContractState, to_chain: felt252, to_handler: u256, payload_type :u8,payload: Array<u8>,
        ) -> felt252 {
            let from_handler = get_caller_address();
            let from_chain = self.chain_name.read();
            let cross_chain_settlement_id = LegacyHash::hash(get_tx_info().unbox().transaction_hash, self.tx_count.read());
            self.created_tx.write(cross_chain_settlement_id, CreatedTx{
                tx_id:cross_chain_settlement_id,
                tx_status: CrossChainMsgStatus::PENDING,
                from_chain: from_chain,
                to_chain: to_chain,
                from_handler: from_handler,
                to_handler: to_handler
            });
            
            self
                .emit(
                    CrossChainMsg {
                        cross_chain_settlement_id: cross_chain_settlement_id,
                        from_address: get_tx_info().unbox().account_contract_address,
                        from_chain: from_chain,
                        to_chain: to_chain,
                        from_handler: from_handler,
                        to_handler: to_handler,
                        payload_type: payload_type,
                        payload: payload
                    }
                );
            self.tx_count.write(self.tx_count.read()+1);
            return cross_chain_settlement_id;
        }

        // @notice receive cross chain message
        // @param cross_chain_msg_id message id
        // @param from_chain message from chain
        // @param to_chain message to chain
        // @param from_handler message from handler
        // @param sign_type signature type for extension
        // @param signatures
        // @param payload message content
        // @param payload_type message type
        fn receive_cross_chain_msg(
            ref self: ContractState,
            cross_chain_msg_id: u256,
            from_chain: felt252,
            to_chain: felt252,
            from_handler: u256,
            to_handler: ContractAddress,
            sign_type: u8,
            signatures: Array<(felt252, felt252, bool)>,
            payload: Array<u8>,
            payload_type: u8,
        ) -> bool {
            assert(to_chain == self.chain_name.read(), 'error to_chain');

            // verify signatures
            let mut message_hash: felt252 = LegacyHash::hash(from_chain, (cross_chain_msg_id, to_chain, from_handler, to_handler));
            let payload_span = payload.span();
            let mut i = 0;
            loop {
                if i > payload_span.len()-1{
                    break;
                }
                message_hash = LegacyHash::hash(message_hash, * payload_span.at(i));
                i += 1;
            };
            self.check_chakra_signatures(message_hash, signatures);

            // call handler receive_cross_chain_msg
            let handler = IHandlerDispatcher{contract_address: to_handler};
            let success = handler.receive_cross_chain_msg(cross_chain_msg_id, from_chain, to_chain, from_handler, to_handler , payload);

            let mut status = CrossChainMsgStatus::SUCCESS;
            if success{
                status = CrossChainMsgStatus::SUCCESS;
            }else{
                status = CrossChainMsgStatus::FAILED;
            }

            self.received_tx.write(cross_chain_msg_id, ReceivedTx{
                tx_id:cross_chain_msg_id,
                from_chain: from_chain,
                from_handler: from_handler,
                to_chain: to_chain,
                to_handler: to_handler,
                tx_status: status
            });

            // emit event
            self.emit(CrossChainHandleResult{
                cross_chain_settlement_id: cross_chain_msg_id,
                from_chain: to_chain,
                from_handler: to_handler,
                to_chain: from_chain,
                to_handler: from_handler,
                cross_chain_msg_status: status,
                payload_type: payload_type
            });
            return true;
        }

        // @notice receive cross chain callback
        // @param cross_chain_msg_id message id
        // @param from_chain message from chain
        // @param to_chain message to chain
        // @param from_handler message from handler
        // @param cross_chain_msg_status message status
        // @param sign_type signature type for extension
        // @param signatures
        fn receive_cross_chain_callback(
            ref self: ContractState,
            cross_chain_msg_id: felt252,
            from_chain: felt252,
            to_chain: felt252,
            from_handler: u256,
            to_handler: ContractAddress,
            cross_chain_msg_status: u8,
            sign_type: u8,
            signatures: Array<(felt252, felt252, bool)>,
        ) -> bool {
            assert(self.created_tx.read(cross_chain_msg_id).tx_id == cross_chain_msg_id, 'message id error');
            assert(self.created_tx.read(cross_chain_msg_id).from_chain == to_chain, 'from_chain error');
            assert(self.created_tx.read(cross_chain_msg_id).to_chain == from_chain, 'to_chain error');
            assert(self.created_tx.read(cross_chain_msg_id).from_handler == to_handler, 'from_handler error');
            assert(self.created_tx.read(cross_chain_msg_id).to_handler == from_handler, 'to_handler error');
            assert(self.created_tx.read(cross_chain_msg_id).tx_status == CrossChainMsgStatus::PENDING, 'tx status error');

            let mut message_hash_temp: felt252 = LegacyHash::hash(from_chain, (cross_chain_msg_id, to_chain, from_handler, to_handler));
            let message_hash_final:felt252 = LegacyHash::hash(message_hash_temp, cross_chain_msg_status);
            self.check_chakra_signatures(message_hash_final, signatures);
            let handler = IHandlerDispatcher{contract_address: to_handler};
            let success = handler.receive_cross_chain_callback(cross_chain_msg_id, from_chain, to_chain, from_handler, to_handler , cross_chain_msg_status);
            let mut state = CrossChainMsgStatus::PENDING;
            if success{
                state = CrossChainMsgStatus::SUCCESS;
            }else{
                state = CrossChainMsgStatus::FAILED;
            }
            
            self.created_tx.write(cross_chain_msg_id, CreatedTx{
                tx_id:cross_chain_msg_id,
                tx_status:state,
                from_chain: to_chain,
                to_chain: from_chain,
                from_handler: to_handler,
                to_handler: from_handler
            });

            self.emit(CrossChainResult {
                cross_chain_settlement_id: cross_chain_msg_id,
                from_address: get_tx_info().unbox().account_contract_address,
                from_chain: to_chain,
                from_handler: to_handler,
                to_chain: from_chain,
                to_handler: from_handler,
                cross_chain_msg_status: state,
            });
            return true;
        }

        fn message_hash_receive(self: @ContractState, cross_chain_msg_id: u256, from_chain: felt252, to_chain: felt252, from_handler: u256, to_handler: ContractAddress, payload: Array<u8>) -> felt252{
            let mut message_hash: felt252 = LegacyHash::hash(from_chain, (cross_chain_msg_id, to_chain, from_handler, to_handler));
            let payload_span = payload.span();
            let mut i = 0;
            loop {
                if i > payload_span.len()-1{
                    break;
                }
                message_hash = LegacyHash::hash(message_hash, * payload_span.at(i));
                i += 1;
            };
            return message_hash;
        }

        fn message_hash_callback(self: @ContractState, cross_chain_msg_id: felt252, from_chain: felt252, to_chain: felt252,from_handler: u256, to_handler: ContractAddress, cross_chain_msg_status: u8) -> felt252{
            let mut message_hash_temp: felt252 = LegacyHash::hash(from_chain, (cross_chain_msg_id, to_chain, from_handler, to_handler));
            let message_hash:felt252 = LegacyHash::hash(message_hash_temp, cross_chain_msg_status);
            return message_hash;
        }

        fn get_recevied_tx(self: @ContractState, tx_id: u256) -> ReceivedTx{
            return self.received_tx.read(tx_id);
        }

        fn get_created_tx(self: @ContractState, tx_id: felt252) -> CreatedTx{
            return self.created_tx.read(tx_id);
        }

        fn set_chain_name(ref self: ContractState, chain_name: felt252){
            self.ownable.assert_only_owner();
            self.chain_name.write(chain_name);
        }

        fn chain_name(self: @ContractState) -> felt252{
            return self.chain_name.read();
        }

    }

    #[abi(embed_v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            // This function can only be called by the owner
            self.ownable.assert_only_owner();

            // Replace the class hash upgrading the contract
            self.upgradeable.upgrade(new_class_hash);
        }
    }
}