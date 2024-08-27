use core::array::ArrayTrait;
use starknet::ContractAddress;
use settlement_cairo::utils::{u8_array_to_u256, u256_to_u8_array};

#[derive(Drop)]
pub struct Message {
    pub version: u8,
    pub message_id: u256,
    pub payload_type: u8,
    pub payload: Array<u8>
}

#[derive(Drop)]
pub struct ERC20Transfer{
    pub method_id: u8,
    pub from: u256,
    pub to: u256,
    pub from_token: u256,
    pub to_token: u256,
    pub amount: u256
}

pub fn decode_message(payload: Array<u8>) -> Message{
    let mut version = 0;
    let mut payload_type = 0;
    let mut message_id_array = ArrayTrait::new();
    let mut message_payload = ArrayTrait::new();
    let mut i = 0;
    loop{
        if i <= 0{
            version = * payload.span().at(i);
        }else if i<= 32{
            message_id_array.append(* payload.span().at(i));
        }else if i <= 33{
            payload_type = * payload.span().at(i);
        }else if i <= payload.span().len()-1{
            message_payload.append(* payload.span().at(i));
        }else{
            break;
        }
        i+=1;
    };

    let message_id: u256 = u8_array_to_u256(message_id_array.span());
    
    return Message{
        version: version,
        message_id: message_id,
        payload_type: payload_type,
        payload: message_payload
    };
}

pub fn decode_transfer(payload: Array<u8>) -> ERC20Transfer{
    let method_id:u8 = * payload.span().at(0);
    let mut i:usize = 1;
    let mut from_payload = ArrayTrait::new();
    let mut to_payload = ArrayTrait::new();
    let mut from_token_payload = ArrayTrait::new();
    let mut to_token_payload = ArrayTrait::new();
    let mut amount_payload = ArrayTrait::new();
    loop {
        if i <= 32{
            from_payload.append(* payload.span().at(i));
        }else if i<= 64{
            to_payload.append(* payload.span().at(i));
        }else if i<= 96{
            from_token_payload.append(* payload.span().at(i));
        }else if i<= 128{
            to_token_payload.append(* payload.span().at(i));
        }else if i<= 160{
            amount_payload.append(* payload.span().at(i));
        }else{
            break;
        }
        i += 1;
    };
    let from = u8_array_to_u256(from_payload.span());
    let to = u8_array_to_u256(to_payload.span());
    let from_token = u8_array_to_u256(from_token_payload.span());
    let to_token = u8_array_to_u256(to_token_payload.span());
    let amount = u8_array_to_u256(amount_payload.span());
    return ERC20Transfer{
        method_id: method_id,
        from : from,
        to: to,
        from_token: from_token,
        to_token: to_token,
        amount: amount
    };
}

pub fn encode_message(message: Message) -> Array<u8>{
    let mut array_u8 = ArrayTrait::new();
    let version: u8 = 1;
    array_u8.append(version);
    let message_id_array: Array<u8> = u256_to_u8_array(message.message_id);
    let mut i = 0;
    loop{
        if i > message_id_array.len() -1 {
            break;
        }
        array_u8.append(* message_id_array.span().at(i));
        i += 1;
    };
    let payload_type: u8 = message.payload_type;
    array_u8.append(payload_type);
    let mut i = 0;
    loop{
        if i > message.payload.len() -1{
            break;
        }
        array_u8.append(* message.payload.span().at(i));
        i += 1;
    };
    return array_u8;
}

pub fn encode_transfer(transfer: ERC20Transfer) -> Array<u8>{
    let mut array_u8 = ArrayTrait::new();
    let method_id = transfer.method_id;
    array_u8.append(method_id);
    let from: u256 = transfer.from;
    let from_u8_array: Array<u8> = u256_to_u8_array(from);
    assert(from_u8_array.len() == 32, 'len error 1');
    let mut i = 0;
    loop {
        if i > from_u8_array.len()-1{
            break;
        }
        array_u8.append(* from_u8_array.span().at(i));
        i+=1;
    };

    let to: u256 = transfer.to;
    let to_u8_array: Array<u8> = u256_to_u8_array(to);
    let mut i = 0;
    assert(to_u8_array.len() == 32, 'len error 2');
    loop {
        if i > to_u8_array.len()-1{
            break;
        }
        array_u8.append(* to_u8_array.span().at(i));
        i+=1;
    };

    let from_token: u256 = transfer.from_token;
    let from_token_u8_array: Array<u8> = u256_to_u8_array(from_token);
    let mut i =0;
    assert(from_token_u8_array.len() == 32, 'len error 3');
    loop {
        if i > from_token_u8_array.len()-1{
            break;
        }
        array_u8.append(* from_token_u8_array.span().at(i));
        i+=1;
    };

    let to_token: u256 = transfer.to_token;
    let to_token_u8_array: Array<u8> = u256_to_u8_array(to_token);
    let mut i =0;
    assert(to_token_u8_array.len() == 32, 'len error 4');
    loop {
        if i > to_token_u8_array.len()-1{
            break;
        }
        array_u8.append(* to_token_u8_array.span().at(i));
        i+=1;
    };

    let amount: u256 = transfer.amount;
    let amount_u8_array: Array<u8> = u256_to_u8_array(amount);
    let mut i =0;
    assert(amount_u8_array.len() == 32, 'len error 5');
    loop {
        if i > amount_u8_array.len()-1{
            break;
        }
        array_u8.append(* amount_u8_array.span().at(i));
        i+=1;
    };

    return array_u8;
}