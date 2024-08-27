from starknet_py.net.account.account import Account
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.contract import Contract
from starknet_py.cairo.felt import encode_shortstring

from dotenv import load_dotenv
from os import environ
from asyncio import run
from aiofiles import open as aopen
from ujson import loads as uloads


load_dotenv()

client = FullNodeClient("https://starknet-sepolia.public.blastapi.io/rpc/v0_7")


ACCOUNT_ADDRESS = environ.get("account_address")
ACCOUNT_PRIVATE_KEY = environ.get("account_private_key")
ACCOUNT_PUBLIC_KEY = environ.get("account_public_key")
CHAIN_ID = (
    StarknetChainId.SEPOLIA
    if environ.get("chainId") == "sepolia"
    else StarknetChainId.MAINNET
)

account = Account(
    client=client,
    address=ACCOUNT_ADDRESS,
    key_pair=KeyPair(private_key=ACCOUNT_PRIVATE_KEY, public_key=ACCOUNT_PUBLIC_KEY),
    chain=StarknetChainId.SEPOLIA,
)

if None in (ACCOUNT_ADDRESS, ACCOUNT_PRIVATE_KEY, ACCOUNT_PUBLIC_KEY):
    print("ACCOUNT_ADDRESS,ACCOUNT_PRIVATE_KEY,ACCOUNT_PUBLIC_KEY CONNOT BE EMPTY")


async def main():
    pass


async def deployer(compiled_contract: str, need_declare: bool = False):
    if need_declare:
        declare_res = await declarer(compiled_contract)
    else:
        pass


async def declarer(compiled_contract: str) -> dict:
    compiled_contract_contents = ""
    # settlement_cairo_ckrBTC.contract_class.json
    async with aopen(f"../target/dev/{compiled_contract}") as f:
        compiled_contract_contents = await f.read()

    compiled_contract_casm_contents = ""
    # settlement_cairo_ckrBTC.contract_class.json
    async with aopen(
        "../target/dev/settlement_cairo_ckrBTC.compiled_contract_class.json"
    ) as f:
        compiled_contract_casm_contents = await f.read()

    declare_result = await Contract.declare_v3(
        account,
        compiled_contract_contents,
        compiled_contract_casm=compiled_contract_casm_contents,
        auto_estimate=True,
    )
    await declare_result.wait_for_acceptance()
    print(declare_result.class_hash)
    print("Declare Result:", declare_result)
    return declare_result


async def test():
    print("Prepare to deploying contracts...")
    await declarer("settlement_cairo_ckrBTC.contract_class.json")


print(run(test()))
