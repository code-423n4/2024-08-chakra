use starknet::ContractAddress;

#[starknet::interface]
pub trait IckrBTC<TContractState> {
    fn add_manager(ref self: TContractState, new_manager: ContractAddress) -> bool;
    fn remove_manager(ref self: TContractState, old_manager: ContractAddress) -> bool;
    fn is_manager(self: @TContractState, manager: ContractAddress) -> bool;
    fn add_operator(ref self: TContractState, new_operator: ContractAddress) -> bool;
    fn remove_operator(ref self: TContractState, old_operator: ContractAddress) -> bool;
    fn is_operator(self: @TContractState, operator: ContractAddress) -> bool;
    fn mint_to(ref self: TContractState, to: ContractAddress, amount: u256) -> bool;
    fn burn_from(ref self: TContractState, to: ContractAddress, amount: u256) -> bool;
}


#[starknet::contract]
mod ckrBTC {
    use openzeppelin::token::erc20::erc20::ERC20Component::InternalTrait;
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::num::traits::Zero;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use starknet::ClassHash;
    use starknet::get_block_timestamp;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);
    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    // ERC20 Mixin
    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    // Ownable Mixin
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;


    /// Upgradeable
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    pub mod Errors {
        pub const NOT_OWNER: felt252 = 'address is not the owner';
        pub const NOT_MANAGER: felt252 = 'address is not a manager';
        pub const ALREADY_MANAGER: felt252 = 'address is a manager already';
        pub const NOT_OPERATOR: felt252 = 'address is not a operator';
        pub const BALANCE_NOT_ENOUGH: felt252 = 'balance not enough';
        pub const ALREADY_OPERATOR: felt252 = 'address is a operator already';
        pub const ZERO_ADDRESS_CALLER: felt252 = 'address is the zero address';
        pub const ZERO_ADDRESS_OWNER: felt252 = 'New owner is the zero address';
    }


    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        chakra_operators: LegacyMap<ContractAddress, u8>,
        chakra_managers: LegacyMap<ContractAddress, u8>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.ownable.initializer(owner);

        let name = "ckrBTC";
        let symbol = "CBTC";

        self.erc20.initializer(name, symbol);
        self.chakra_managers.write(owner, 1);
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
        #[flat]
        ERC20Event: ERC20Component::Event,
        ManagerAdded: ManagerAdded,
        ManagerRemoved: ManagerRemoved,
        OperatorAdded: OperatorAdded,
        OperatorRemoved: OperatorRemoved,
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
    pub struct OperatorAdded {
        #[key]
        pub new_operator: ContractAddress,
        pub added_at: u64
    }


    #[derive(Drop, PartialEq, starknet::Event)]
    pub struct OperatorRemoved {
        #[key]
        pub old_operator: ContractAddress,
        pub removed_at: u64
    }

    #[abi(embed_v0)]
    impl ckrBTCImpl of super::IckrBTC<ContractState> {
        // Managers related operations

        fn add_manager(ref self: ContractState, new_manager: ContractAddress) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, Errors::NOT_MANAGER);
            assert(self.chakra_managers.read(new_manager) == 0, Errors::ALREADY_MANAGER);

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
            assert(self.chakra_managers.read(caller) == 1, Errors::NOT_MANAGER);
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

        // Operators related operations

        fn add_operator(ref self: ContractState, new_operator: ContractAddress) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, Errors::NOT_MANAGER);
            assert(self.chakra_operators.read(new_operator) == 0, Errors::ALREADY_OPERATOR);

            self.chakra_operators.write(new_operator, 1);
            self
                .emit(
                    OperatorAdded { new_operator: new_operator, added_at: get_block_timestamp() }
                );
            return self.chakra_operators.read(new_operator) == 1;
        }
        fn remove_operator(ref self: ContractState, old_operator: ContractAddress) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_managers.read(caller) == 1, Errors::NOT_MANAGER);
            assert(self.chakra_operators.read(old_operator) == 1, Errors::NOT_OPERATOR);
            self.chakra_operators.write(old_operator, 0);
            self
                .emit(
                    OperatorRemoved {
                        old_operator: old_operator, removed_at: get_block_timestamp()
                    }
                );
            return self.chakra_operators.read(old_operator) == 0;
        }
        fn is_operator(self: @ContractState, operator: ContractAddress) -> bool {
            return self.chakra_operators.read(operator) == 1;
        }


        fn mint_to(ref self: ContractState, to: ContractAddress, amount: u256) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_operators.read(caller) == 1, Errors::NOT_OPERATOR);
            let old_balance = self.erc20.balance_of(to);
            self.erc20.mint(to, amount);
            let new_balance = self.erc20.balance_of(to);
            return new_balance == old_balance + amount;
        }


        fn burn_from(ref self: ContractState, to: ContractAddress, amount: u256) -> bool {
            let caller = get_caller_address();
            assert(self.chakra_operators.read(caller) == 1, Errors::NOT_OPERATOR);
            let old_balance = self.erc20.balance_of(to);
            assert(old_balance >= amount, Errors::BALANCE_NOT_ENOUGH);
            self.erc20.burn(to, amount);
            let new_balance = self.erc20.balance_of(to);
            return new_balance == old_balance - amount;
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
