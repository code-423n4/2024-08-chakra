#[starknet::contract]
mod ERC20Handler{
    use openzeppelin::access::ownable::interface::OwnableABI;
    use core::option::OptionTrait;
    use core::traits::Into;
    use core::traits::TryInto;
    use core::starknet::event::EventEmitter;
    use core::box::BoxTrait;
    use settlement_cairo::interfaces::{IChakraSettlementDispatcherTrait, IERC20Dispatcher, IERC20DispatcherTrait, IERC20MintDispatcher, IERC20MintDispatcherTrait};
    use starknet::ContractAddress;
    use settlement_cairo::interfaces::IERC20Handler;
    use settlement_cairo::interfaces::IChakraSettlementDispatcher;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use starknet::ClassHash;
    use starknet::{get_caller_address, get_tx_info, get_contract_address};
    use core::hash::LegacyHash;
    use settlement_cairo::codec::{decode_transfer, encode_transfer, ERC20Transfer, Message, decode_message, encode_message};
    use settlement_cairo::utils::{u256_to_contract_address, contract_address_to_u256};
    use settlement_cairo::constant::{CrossChainTxStatus, ERC20Method, PayloadType, SettlementMode};

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

    // Ownable Mixin
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // Upgradeable
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    #[constructor]
    fn constructor(ref self: ContractState, settlement_address: ContractAddress, owner: ContractAddress, token_address: ContractAddress, mode: u8) {
        assert(mode<=3, 'invalid mode');
        self.settlement_address.write(settlement_address);
        self.ownable.initializer(owner);
        self.token_address.write(token_address);
        self.mode.write(mode);
    }

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
        settlement_address: ContractAddress,
        token_address: ContractAddress,
        created_tx: LegacyMap<felt252, CreatedCrossChainTx>,
        msg_count: u256,
        support_handler: LegacyMap<(felt252, u256), bool>,
        mode: u8
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
        WithdrawLocked: WithdrawLocked,
        CrossChainLocked: CrossChainLocked
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct WithdrawLocked {
        #[key]
        pub withdraw_tx_id: felt252,
        #[key]
        pub from_address: ContractAddress,
        pub to_address: u256,
        pub amount: u256
    }

    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct CrossChainLocked {
        #[key]
        pub tx_id: felt252,
        #[key]
        pub from: ContractAddress,
        #[key]
        pub to: u256,
        pub from_chain: felt252,
        pub to_chain: felt252,
        pub from_token: ContractAddress,
        pub to_token: u256,
        pub amount: u256
    }

    #[derive(Drop, Serde, starknet::Store)]
    pub struct CreatedCrossChainTx {
       tx_id : felt252,
       from_chain: felt252,
       to_chain: felt252,
       from: ContractAddress,
       to: u256,
       from_token: ContractAddress,
       to_token: u256,
       amount: u256,
       tx_status: u8
    }

    #[abi(embed_v0)]
    impl ERC20HandlerImpl of IERC20Handler<ContractState> {
        fn receive_cross_chain_msg(ref self: ContractState, cross_chain_msg_id: u256, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, payload: Array<u8>) -> bool{
            assert(to_handler == get_contract_address(),'error to_handler');

            assert(self.settlement_address.read() == get_caller_address(), 'not settlement');

            assert(self.support_handler.read((from_chain, from_handler)) && 
                    self.support_handler.read((to_chain, contract_address_to_u256(to_handler))), 'not support handler');

            let message :Message= decode_message(payload);
            let payload_type = message.payload_type;
            assert(payload_type == PayloadType::ERC20, 'payload type not erc20');
            let payload_transfer = message.payload;
            let transfer = decode_transfer(payload_transfer);
            assert(transfer.method_id == ERC20Method::TRANSFER, 'ERC20Method must TRANSFER');
            let erc20 = IERC20MintDispatcher{contract_address: self.token_address.read()};
            let token = IERC20Dispatcher{contract_address: self.token_address.read()};
            if self.mode.read() == SettlementMode::MintBurn{
                erc20.mint_to(u256_to_contract_address(transfer.to), transfer.amount);
            }else if self.mode.read() == SettlementMode::LockMint{
                erc20.mint_to(u256_to_contract_address(transfer.to), transfer.amount);
            }else if self.mode.read() == SettlementMode::BurnUnlock{
                token.transfer(u256_to_contract_address(transfer.to), transfer.amount);
            }else if self.mode.read() == SettlementMode::LockUnlock{
                token.transfer(u256_to_contract_address(transfer.to), transfer.amount);
            }
            
            return true;
        }

        fn receive_cross_chain_callback(ref self: ContractState, cross_chain_msg_id: felt252, from_chain: felt252, to_chain: felt252,
        from_handler: u256, to_handler: ContractAddress, cross_chain_msg_status: u8) -> bool{
            assert(to_handler == get_contract_address(),'error to_handler');

            assert(self.settlement_address.read() == get_caller_address(), 'not settlement');

            assert(self.support_handler.read((from_chain, from_handler)) && 
                    self.support_handler.read((to_chain, contract_address_to_u256(to_handler))), 'not support handler');

            let erc20 = IERC20MintDispatcher{contract_address: self.token_address.read()};
            if self.mode.read() == SettlementMode::MintBurn{
                erc20.burn_from(get_contract_address(), self.created_tx.read(cross_chain_msg_id).amount);
            }
            let created_tx = self.created_tx.read(cross_chain_msg_id);
            self.created_tx.write(cross_chain_msg_id, CreatedCrossChainTx{
                tx_id: created_tx.tx_id,
                from_chain: created_tx.from_chain,
                to_chain: created_tx.to_chain,
                from:created_tx.from,
                to:created_tx.to,
                from_token: created_tx.from_token,
                to_token: created_tx.to_token,
                amount: created_tx.amount,
                tx_status: CrossChainTxStatus::SETTLED
            });

            return true;
        }

        fn cross_chain_erc20_settlement(ref self: ContractState, to_chain: felt252, to_handler: u256, to_token: u256, to: u256, amount: u256) -> felt252{
            assert(self.support_handler.read((to_chain, to_handler)), 'not support handler');
            let settlement = IChakraSettlementDispatcher {contract_address: self.settlement_address.read()};
            let from_chain = settlement.chain_name();
            let token = IERC20Dispatcher{contract_address: self.token_address.read()};
            let token_burnable = IERC20MintDispatcher{contract_address: self.token_address.read()};
            if self.mode.read() == SettlementMode::MintBurn{
                token.transfer_from(get_caller_address(), get_contract_address(), amount);
            }else if self.mode.read() == SettlementMode::LockMint{
                token.transfer_from(get_caller_address(), get_contract_address(), amount);
            }else if self.mode.read() == SettlementMode::BurnUnlock{
                token_burnable.burn_from(get_caller_address(), amount);
            }else if self.mode.read() == SettlementMode::LockUnlock{
                token.transfer_from(get_caller_address(), get_contract_address(), amount);
            }
            
            let tx_id = LegacyHash::hash(get_tx_info().unbox().transaction_hash, self.msg_count.read());
            let tx: CreatedCrossChainTx = CreatedCrossChainTx{
                    tx_id: tx_id,
                    from_chain: from_chain,
                    to_chain: to_chain,
                    from: get_contract_address(),
                    to: to,
                    from_token: self.token_address.read(),
                    to_token: to_token,
                    amount: amount,
                    tx_status: CrossChainTxStatus::PENDING
                };
            self.created_tx.write(tx_id, tx);
            self.msg_count.write(self.msg_count.read()+1);
            // message id = message count
            let message_id = tx_id;
            let transfer = ERC20Transfer{
                method_id: 1,
                from: contract_address_to_u256(get_caller_address()),
                to: to,
                from_token: contract_address_to_u256(self.token_address.read()),
                to_token: to_token,
                amount: amount
            };

            let message = Message{
                version: 1,
                message_id: message_id.into(),
                payload_type: PayloadType::ERC20,
                payload: encode_transfer(transfer),
            };
            
            // send cross chain msg
            settlement.send_cross_chain_msg(to_chain, to_handler, PayloadType::ERC20, encode_message(message));
            // emit CrossChainLocked

            self.emit(
                    CrossChainLocked{
                        tx_id: tx_id,
                        from: get_caller_address(),
                        to: to,
                        from_chain: get_tx_info().unbox().chain_id,
                        to_chain: to_chain,
                        from_token: self.token_address.read(),
                        to_token: to_token,
                        amount: amount
                    }
                );
            return tx_id;
        }

        fn is_valid_handler(self: @ContractState, chain_name: felt252, handler: u256) -> bool{
            return self.support_handler.read((chain_name, handler));
        }

        fn set_support_handler(ref self:ContractState, chain_name: felt252, handler: u256, support: bool){
            self.ownable.assert_only_owner();
            self.support_handler.write((chain_name, handler), support);
        }

        fn upgrade_settlement(ref self:ContractState, new_settlement: ContractAddress){
            self.ownable.assert_only_owner();
            self.settlement_address.write(new_settlement);
        }

        fn view_settlement(self: @ContractState) -> ContractAddress{
            return self.settlement_address.read();
        }

        fn mode(self: @ContractState) -> u8{
            return self.mode.read();
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