use core::option::OptionTrait;
use core::traits::TryInto;
use settlement_cairo::ckr_btc::IckrBTCDispatcherTrait;
use openzeppelin::token::erc20::interface::IERC20DispatcherTrait;
use core::result::ResultTrait;
use core::box::BoxTrait;
use snforge_std::{declare, ContractClassTrait, start_prank, CheatTarget, stop_prank};
use starknet::ContractAddress;
use starknet::{get_tx_info, get_caller_address};
use settlement_cairo::interfaces::{IERC20HandlerDispatcher, IERC20HandlerDispatcherTrait, IChakraSettlementDispatcher, IChakraSettlementDispatcherTrait};
use settlement_cairo::codec::{decode_transfer, encode_transfer, ERC20Transfer, Message, decode_message, encode_message};
use settlement_cairo::utils::{u256_to_contract_address, contract_address_to_u256, u256_to_u8_array};
use settlement_cairo::ckr_btc::{IckrBTCDispatcher};
use openzeppelin::token::erc20::interface::IERC20Dispatcher;

#[test]
fn test_erc20_codec(){
    // test erc20 codec
    let array_u8 = array! [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    let span_array_u8 = array_u8.span();
    let transfer = decode_transfer(array_u8);
    assert(transfer.method_id == 1, 'method_id error');
    assert(transfer.from == 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266, 'from error');
    assert(transfer.to == 0x70997970c51812dc3a010c7d01b50e0d17dc79c8,'to error');
    assert(transfer.from_token == 1324161310598743833836268493538283093091898295570, 'from_token error');
    assert(transfer.to_token == 0x90f79bf6eb2c4f870365e785982e1f101e93b906, 'to_token error');
    assert(transfer.amount == 1000, 'amount error');

    let transfer = ERC20Transfer{
        method_id:1,
        from:0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266,
        to:0x70997970c51812dc3a010c7d01b50e0d17dc79c8,
        from_token:1324161310598743833836268493538283093091898295570,
        to_token:0x90f79bf6eb2c4f870365e785982e1f101e93b906,
        amount:1000
    };

    let encoded_array_u8 = encode_transfer(transfer);
    assert(encoded_array_u8.len() == 161, 'len error');
    assert(span_array_u8.at(0) == encoded_array_u8.at(0), 'aaaa');
    assert(span_array_u8.at(2) == encoded_array_u8.at(2), '11111');
    assert(span_array_u8.at(23) == encoded_array_u8.at(23), 'bbbb');
    assert(span_array_u8.at(55) == encoded_array_u8.at(55), 'cccc');
    assert(span_array_u8.at(84) == encoded_array_u8.at(84), 'dddd');
    assert(span_array_u8.at(119) == encoded_array_u8.at(119), 'eeee');
    assert(span_array_u8.at(151) == encoded_array_u8.at(151), 'ffff');
}

#[test]
fn test_message_codec(){
    // test message codec
    let message_array_u8 = array! [1, 226, 26, 80, 2, 232, 11, 172, 207, 254, 0, 95, 72, 69, 136, 99, 38, 6, 228, 108, 177, 62, 5, 10, 125, 58, 52, 32, 110, 139, 85, 224, 141, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    let span_u8 = message_array_u8.span();
    let message: Message= decode_message(message_array_u8);
    assert(message.message_id == 102269194021567332847914370237131713785896093488773568729203804469433919201421,'id error');
    assert(message.payload_type == 5, 'payload_type error');
    let payload = array! [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    let message = Message{
        version:1,
        message_id:102269194021567332847914370237131713785896093488773568729203804469433919201421,
        payload_type:5,
        payload:payload,
    };

    let encoded_message_array_u8 = encode_message(message);
    
    assert(encoded_message_array_u8.at(0) == span_u8.at(0), 'aaaa');
    assert(encoded_message_array_u8.at(23) == span_u8.at(23), 'bbbb');
    assert(encoded_message_array_u8.at(55) == span_u8.at(55), 'cccc');
    assert(encoded_message_array_u8.at(84) == span_u8.at(84), 'dddd');
    assert(encoded_message_array_u8.at(119) == span_u8.at(119), 'eeee');
    assert(encoded_message_array_u8.at(151) == span_u8.at(151), 'ffff');
}

#[test]
fn test_mint_burn(){
    let source_chain = 'Starknet';
    let target_chain = 'Scroll';
    let target_handler = 2;
    let target_token = 1;
    let target_address = 1;
    let amount = 1000;
    let owner_address = 0x5a9bd6214db5b229bd17a4050585b21c87fc0cadf9871f89a099d27ef800a40;

    let settlement_contract = declare("ChakraSettlement");
    let settlement_address = settlement_contract.deploy(@array![owner_address, 1]).unwrap();
    let ckrBTC_contract = declare("ckrBTC");
    let ckrBTC_address = ckrBTC_contract.deploy(@array![owner_address]).unwrap();
    let erc20_handler = declare("ERC20Handler");
    let erc20_handler_address = erc20_handler.deploy(@array![settlement_address.into(),owner_address,ckrBTC_address.into(), 0]).unwrap();
    
    let handler_dispath = IERC20HandlerDispatcher {contract_address: erc20_handler_address};
    let ckrbtc_dispath = IckrBTCDispatcher{contract_address: ckrBTC_address};
    let ckrbtc_erc20_dispath = IERC20Dispatcher{contract_address: ckrBTC_address};
    // test support handler
    let owner = owner_address.try_into().unwrap();
    start_prank(CheatTarget::One(erc20_handler_address), owner);
    // add from_chain from_handler
    handler_dispath.set_support_handler(source_chain, contract_address_to_u256(erc20_handler_address),true);
    
    // add to_chain to_handler
    handler_dispath.set_support_handler(target_chain, target_handler,true);

    start_prank(CheatTarget::One(ckrBTC_address), owner);
    ckrbtc_dispath.add_operator(owner);
    // cross_chain_erc20_settlement
    ckrbtc_dispath.mint_to(owner, amount);
    ckrbtc_erc20_dispath.approve(erc20_handler_address, 100000000);
    stop_prank(CheatTarget::One(ckrBTC_address));
    assert(ckrbtc_erc20_dispath.allowance(owner, erc20_handler_address)==100000000, 'approve error');
    assert(ckrbtc_erc20_dispath.balance_of(owner) == amount, 'balance error');
    let tx_id = handler_dispath.cross_chain_erc20_settlement(target_chain, target_handler, target_token, target_address, amount);
    assert(ckrbtc_erc20_dispath.balance_of(owner) == 0, 'balance error after cross');
    assert(ckrbtc_erc20_dispath.balance_of(erc20_handler_address) == amount, 'handler balance error');
    // receive_cross_chain_msg
    start_prank(CheatTarget::One(ckrBTC_address), owner);
    start_prank(CheatTarget::One(erc20_handler_address), settlement_address);
    let message_array_u8 = array! [1, 226, 26, 80, 2, 232, 11, 172, 207, 254, 0, 95, 72, 69, 136, 99, 38, 6, 228, 108, 177, 62, 5, 10, 125, 58, 52, 32, 110, 139, 85, 224, 141, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    handler_dispath.receive_cross_chain_msg(1, target_chain, source_chain, target_handler, erc20_handler_address, message_array_u8);
    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == 1000, 'transfer error');
    // receive_cross_chain_callback
    handler_dispath.receive_cross_chain_callback(tx_id, target_chain, source_chain, target_handler, erc20_handler_address, 1);
    assert(ckrbtc_erc20_dispath.balance_of(erc20_handler_address) == 0, 'handler balance error');
}

#[test]
fn test_lock_mint(){
    let source_chain = 'Starknet';
    let target_chain = 'Scroll';
    let target_handler = 2;
    let target_token = 1;
    let target_address = 1;
    let amount = 1000;
    let owner_address = 0x5a9bd6214db5b229bd17a4050585b21c87fc0cadf9871f89a099d27ef800a40;

    let settlement_contract = declare("ChakraSettlement");
    let settlement_address = settlement_contract.deploy(@array![owner_address, 1]).unwrap();
    let ckrBTC_contract = declare("ckrBTC");
    let ckrBTC_address = ckrBTC_contract.deploy(@array![owner_address]).unwrap();
    let erc20_handler = declare("ERC20Handler");
    let erc20_handler_address = erc20_handler.deploy(@array![settlement_address.into(),owner_address,ckrBTC_address.into(), 1]).unwrap();
    
    let handler_dispath = IERC20HandlerDispatcher {contract_address: erc20_handler_address};
    let ckrbtc_dispath = IckrBTCDispatcher{contract_address: ckrBTC_address};
    let ckrbtc_erc20_dispath = IERC20Dispatcher{contract_address: ckrBTC_address};
    // test support handler
    let owner = owner_address.try_into().unwrap();
    start_prank(CheatTarget::One(erc20_handler_address), owner);
    // add from_chain from_handler
    handler_dispath.set_support_handler(source_chain, contract_address_to_u256(erc20_handler_address),true);
    
    // add to_chain to_handler
    handler_dispath.set_support_handler(target_chain, target_handler,true);

    start_prank(CheatTarget::One(ckrBTC_address), owner);
    ckrbtc_dispath.add_operator(owner);
    // cross_chain_erc20_settlement
    ckrbtc_dispath.mint_to(owner, amount);
    
    ckrbtc_erc20_dispath.approve(erc20_handler_address, 100000000);
    stop_prank(CheatTarget::One(ckrBTC_address));
    assert(ckrbtc_erc20_dispath.allowance(owner, erc20_handler_address)==100000000, 'approve error');
    assert(ckrbtc_erc20_dispath.balance_of(owner) == amount, 'balance error');
    handler_dispath.cross_chain_erc20_settlement(target_chain, target_handler, target_token, target_address, amount);
    assert(ckrbtc_erc20_dispath.balance_of(owner) == 0, 'balance error after cross');
    assert(ckrbtc_erc20_dispath.balance_of(erc20_handler_address) == amount, 'handler balance error');
    // receive_cross_chain_msg
    start_prank(CheatTarget::One(ckrBTC_address), owner);
    start_prank(CheatTarget::One(erc20_handler_address), settlement_address);

    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == 0, 'to_address balance error');
    let message_array_u8 = array! [1, 226, 26, 80, 2, 232, 11, 172, 207, 254, 0, 95, 72, 69, 136, 99, 38, 6, 228, 108, 177, 62, 5, 10, 125, 58, 52, 32, 110, 139, 85, 224, 141, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    handler_dispath.receive_cross_chain_msg(1, target_chain, source_chain, target_handler, erc20_handler_address, message_array_u8);
    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == 1000, 'transfer error');
}


#[test]
fn test_burn_unlock(){
    let source_chain = 'Starknet';
    let target_chain = 'Scroll';
    let target_handler = 2;
    let target_token = 1;
    let target_address = 1;
    let amount = 1000;
    let owner_address = 0x5a9bd6214db5b229bd17a4050585b21c87fc0cadf9871f89a099d27ef800a40;

    let settlement_contract = declare("ChakraSettlement");
    let settlement_address = settlement_contract.deploy(@array![owner_address, 1]).unwrap();
    let ckrBTC_contract = declare("ckrBTC");
    let ckrBTC_address = ckrBTC_contract.deploy(@array![owner_address]).unwrap();
    let erc20_handler = declare("ERC20Handler");
    let erc20_handler_address = erc20_handler.deploy(@array![settlement_address.into(),owner_address,ckrBTC_address.into(), 2]).unwrap();
    
    let handler_dispath = IERC20HandlerDispatcher {contract_address: erc20_handler_address};
    let ckrbtc_dispath = IckrBTCDispatcher{contract_address: ckrBTC_address};
    let ckrbtc_erc20_dispath = IERC20Dispatcher{contract_address: ckrBTC_address};
    // test support handler
    let owner = owner_address.try_into().unwrap();
    start_prank(CheatTarget::One(erc20_handler_address), owner);
    // add from_chain from_handler
    handler_dispath.set_support_handler(source_chain, contract_address_to_u256(erc20_handler_address),true);
    
    // add to_chain to_handler
    handler_dispath.set_support_handler(target_chain, target_handler,true);

    start_prank(CheatTarget::One(ckrBTC_address), owner);
    ckrbtc_dispath.add_operator(owner);
    ckrbtc_dispath.add_operator(erc20_handler_address);
    // cross_chain_erc20_settlement
    ckrbtc_dispath.mint_to(owner, amount);
    ckrbtc_erc20_dispath.approve(erc20_handler_address, 100000000);
    stop_prank(CheatTarget::One(ckrBTC_address));
    assert(ckrbtc_erc20_dispath.balance_of(owner) == amount, 'balance error');
    handler_dispath.cross_chain_erc20_settlement(target_chain, target_handler, target_token, target_address, amount);
    assert(ckrbtc_erc20_dispath.balance_of(owner) == 0, 'balance error after cross');
    // receive_cross_chain_msg
    start_prank(CheatTarget::One(ckrBTC_address), owner);
    start_prank(CheatTarget::One(erc20_handler_address), settlement_address);
    ckrbtc_dispath.mint_to(erc20_handler_address, amount);
    stop_prank(CheatTarget::One(ckrBTC_address));
    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == 0, 'to_address balance error');
    let message_array_u8 = array! [1, 226, 26, 80, 2, 232, 11, 172, 207, 254, 0, 95, 72, 69, 136, 99, 38, 6, 228, 108, 177, 62, 5, 10, 125, 58, 52, 32, 110, 139, 85, 224, 141, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    handler_dispath.receive_cross_chain_msg(1, target_chain, source_chain, target_handler, erc20_handler_address, message_array_u8);
    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == amount, 'transfer error');
    assert(ckrbtc_erc20_dispath.balance_of(erc20_handler_address) == 0, 'transfer error');
}

#[test]
fn test_lock_unlock(){
    let source_chain = 'Starknet';
    let target_chain = 'Scroll';
    let target_handler = 2;
    let target_token = 1;
    let target_address = 1;
    let amount = 1000;
    let owner_address = 0x5a9bd6214db5b229bd17a4050585b21c87fc0cadf9871f89a099d27ef800a40;

    let settlement_contract = declare("ChakraSettlement");
    let settlement_address = settlement_contract.deploy(@array![owner_address, 1]).unwrap();
    let ckrBTC_contract = declare("ckrBTC");
    let ckrBTC_address = ckrBTC_contract.deploy(@array![owner_address]).unwrap();
    let erc20_handler = declare("ERC20Handler");
    let erc20_handler_address = erc20_handler.deploy(@array![settlement_address.into(),owner_address,ckrBTC_address.into(), 3]).unwrap();
    
    let handler_dispath = IERC20HandlerDispatcher {contract_address: erc20_handler_address};
    let ckrbtc_dispath = IckrBTCDispatcher{contract_address: ckrBTC_address};
    let ckrbtc_erc20_dispath = IERC20Dispatcher{contract_address: ckrBTC_address};
    // test support handler
    let owner = owner_address.try_into().unwrap();
    start_prank(CheatTarget::One(erc20_handler_address), owner);
    // add from_chain from_handler
    handler_dispath.set_support_handler(source_chain, contract_address_to_u256(erc20_handler_address),true);
    
    // add to_chain to_handler
    handler_dispath.set_support_handler(target_chain, target_handler,true);

    start_prank(CheatTarget::One(ckrBTC_address), owner);
    ckrbtc_dispath.add_operator(owner);
    // cross_chain_erc20_settlement
    ckrbtc_dispath.mint_to(owner, amount);
    
    ckrbtc_erc20_dispath.approve(erc20_handler_address, 100000000);
    stop_prank(CheatTarget::One(ckrBTC_address));
    assert(ckrbtc_erc20_dispath.allowance(owner, erc20_handler_address)==100000000, 'approve error');
    assert(ckrbtc_erc20_dispath.balance_of(owner) == amount, 'balance error');
    handler_dispath.cross_chain_erc20_settlement(target_chain, target_handler, target_token, target_address, amount);
    assert(ckrbtc_erc20_dispath.balance_of(owner) == 0, 'balance error after cross');
    assert(ckrbtc_erc20_dispath.balance_of(erc20_handler_address) == amount, 'handler balance error');
    
    // receive_cross_chain_msg
    start_prank(CheatTarget::One(erc20_handler_address), settlement_address);
    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == 0, 'to_address balance error');
    let message_array_u8 = array! [1, 226, 26, 80, 2, 232, 11, 172, 207, 254, 0, 95, 72, 69, 136, 99, 38, 6, 228, 108, 177, 62, 5, 10, 125, 58, 52, 32, 110, 139, 85, 224, 141, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243, 159, 214, 229, 26, 173, 136, 246, 244, 206, 106, 184, 130, 114, 121, 207, 255, 185, 34, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 153, 121, 112, 197, 24, 18, 220, 58, 1, 12, 125, 1, 181, 14, 13, 23, 220, 121, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 231, 241, 114, 94, 119, 52, 206, 40, 143, 131, 103, 225, 187, 20, 62, 144, 187, 63, 5, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 144, 247, 155, 246, 235, 44, 79, 135, 3, 101, 231, 133, 152, 46, 31, 16, 30, 147, 185, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 232];
    handler_dispath.receive_cross_chain_msg(1, target_chain, source_chain, target_handler, erc20_handler_address, message_array_u8);
    assert(ckrbtc_erc20_dispath.balance_of(u256_to_contract_address(0x70997970c51812dc3a010c7d01b50e0d17dc79c8)) == 1000, 'transfer error');
    assert(ckrbtc_erc20_dispath.balance_of(erc20_handler_address) == 0, 'transfer error');
}