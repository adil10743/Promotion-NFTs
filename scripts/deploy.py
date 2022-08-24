from brownie import network, accounts, config, coPromotionNFT
import brownie
from scripts.automation_scripts import get_account
from web3 import Web3
#ganache-cli --fork https://goerli.infura.io/v3/9a683af859ec496e9cad16fbd65e61b1 
max_fee = 20000000000
priority_fee = 1500000000

    #companyVault: "0xb1Fc5675094Bd70859425E418fd247B7dc21472A"  
    #adil: "0xEcDA1249Af9498C7486f0b9D6774d75C02D7927a"
    #Janis: "0x965067c63dc2E70A905367E7915966079Ea5785B",
    #Roy: "0x70196d2C1CB073716ddA3987B0aC4D036EA024B0",

def deployContract(fromWallet):
    account = get_account(fromWallet)
    print("Account retrieved, back in deploy. Deploying contract...")
    Contract = coPromotionNFT.deploy(

        {"from": account, "max_fee": max_fee, "priority_fee": priority_fee},
        publish_source=config["networks"][network.show_active()].get("verify")
    )

    # max fee can not be bigger than priority fee and 9 zeros in order to get 1gwei from wei so 1000000000wei = 1gwei
    if type(Contract) == brownie.network.contract.ProjectContract:
        print("CONGRATULIEREN ! Contract deployed.")
    else:
        print("UH OH ! Something went wrong.")
    return Contract


def main():
    deployContract("AA")
