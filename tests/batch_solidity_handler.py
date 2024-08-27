import asyncio
from web3 import AsyncWeb3
from web3.middleware import async_geth_poa_middleware
import json
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

rpc_url = os.getenv("CHAKRA_RPC_URL")
contract_address = os.getenv("HANDLER_CONTRACT_ADDRESS")
account_address = os.getenv("CHAKRA_ACCOUNT")
private_key = os.getenv("CHAKRA_ACCOUNT_PRIVATE_KEY")

async def init_client(rpc_url):
    client = AsyncWeb3(AsyncWeb3.AsyncHTTPProvider(rpc_url))

    # Inject the async poa compatibility middleware to the innermost layer
    client.middleware_onion.inject(async_geth_poa_middleware, layer=0)

    is_connected = await client.is_connected()
    if not is_connected:
        print("Not Connected")
        exit()
    return client

async def init_contract(client, contract_address):
    # Load ABI JSON
    with open('abi/solidity.handler.json', 'r') as abi_file:
        contract_abi = json.load(abi_file)

    contract = client.eth.contract(address=contract_address, abi=contract_abi)
    return contract

async def send_transaction(client, contract, nonce, btc_txid, btc_address, receive_address, amount):
    pre_tran = contract.functions.deposit_request(btc_txid, btc_address, receive_address, amount)

    transaction = await pre_tran.build_transaction({
        'chainId': 8545,
        'gas': 2000000,
        'gasPrice': client.to_wei('50', 'gwei'),
        'nonce': nonce,
    })

    signed_txn = client.eth.account.sign_transaction(transaction, private_key)
    txn_hash = await client.eth.send_raw_transaction(signed_txn.rawTransaction)

    print(f"Transaction sent: {txn_hash.hex()}")

    txn_receipt = await client.eth.wait_for_transaction_receipt(txn_hash)
    print(f"Transaction {txn_hash.hex()} confirmed in block {txn_receipt.blockNumber}")

async def main(batch_size):
    client = await init_client(rpc_url)
    contract = await init_contract(client, contract_address)

    initial_nonce = await client.eth.get_transaction_count(account_address)
    print("Initial Nonce: ", initial_nonce)

    # Parameters for multiple transactions
    btc_txids = [12345678910 + i for i in range(batch_size)]  # Example BTC txids
    btc_address = 'tb1p0d8vtv7c0skytnj9rpps495r4726pasfhj4hxxq4ph5gxjhptpws9q698f'
    receive_address = '0x940D583861e57ab1c7F83D5a9450323CAe38402b'
    amount = 1000

    tasks = []
    for i in range(batch_size):  # Number of concurrent transactions
        nonce = initial_nonce + i
        tasks.append(send_transaction(client, contract, nonce, btc_txids[i], btc_address, receive_address, amount))

    await asyncio.gather(*tasks)

if __name__ == '__main__':
    batch_size = 1000
    asyncio.run(main(batch_size))
