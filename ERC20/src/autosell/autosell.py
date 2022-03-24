import time
from web3.auto import Web3
import config
import json

bsc = "https://bsc-dataseed.binance.org/"
testnet = "https://data-seed-prebsc-2-s3.binance.org:8545/" 
web3 = Web3(Web3.HTTPProvider(bsc))
print('Conected to web3 :',  web3.isConnected())

walletAddress = config.YOUR_WALLET_ADDRESS
pancakeRouterAddress = config.PANCAKE_ROUTER_ADDRESS
panRouterContractABI = json.loads(config.PANCAKE_ABI)
wickedDriveABI =  config.WICKED_DRIVE_ABI

TokenToSellAddress =  web3.toChecksumAddress(config.WICKED_DRIVE_ADDRESS)
WBNB_Address =  web3.toChecksumAddress(config.WBNB_ADDRESS)

contractPancake =  web3.eth.contract(address=pancakeRouterAddress, abi=panRouterContractABI)
contractSellToken =  web3.eth.contract(address=TokenToSellAddress, abi=wickedDriveABI)

symbol = contractSellToken.functions.symbol().call()

def main(tokenToSell):
  # Get Token Balance.
  TokenInAccount = contractSellToken.functions.balanceOf(walletAddress).call() 
  # Setting the arpoval for pancakeRouter to transferFrom the TokenInAccount.
  print('Approving to spend: ', TokenInAccount)

  approve = contractSellToken.functions.approve(pancakeRouterAddress, TokenInAccount).buildTransaction({
    'from': walletAddress,
    'gasPrice': web3.toWei('5', 'gwei'),
    'nonce': web3.eth.get_transaction_count(walletAddress)
  })
  # This transactions requires to be signed by the private key.
  signed_txn = web3.eth.account.sign_transaction(approve, private_key=config.YOUR_PRIVATE_KEY)
  tx_token = web3.eth.send_raw_transaction(signed_txn.rawTransaction)
  print(f"Approved: {web3.toHex(tx_token)}")

  time.sleep(10)
  print(f"Swapping {web3.fromWei(tokenToSell, 'ether')} {symbol} for BNB")

  pancakeSwap_txn = contractPancake.functions.swapExactTokensForETH(
    tokenToSell, 0,
    [TokenToSellAddress, WBNB_Address],
    walletAddress,
    (int(time.time() + 1000000))
  ).buildTransaction({
    'from': walletAddress,
    'gasPrice': web3.toWei('5', 'gwei'),
    'nonce': web3.eth.get_transaction_count(walletAddress)
  })

  signed_txn = web3.eth.account.sign_transaction(pancakeSwap_txn, private_key=config.YOUR_PRIVATE_KEY)

  try:
    tx_token = web3.eth.send_raw_transaction(signed_txn.rawTransaction)
    result = [web3.toHex(tx_token), f"Sold {web3.fromWei(tokenToSell, 'ether')} {symbol}"]
    print ('Transfer done: ', result)
    time.sleep(10)

  except ValueError as e:
    if e.args[0].get('message') in 'intrinsic gas too low':
        result = ["Failed", f"ERROR: {e.args[0].get('message')}"]
    else:
        result = ["Failed", f"ERROR: {e.args[0].get('message')} : {e.args[0].get('code')}"]
    print('Error on transfer: ',result)

def handle_event(event):
  if (event['args']['to'] == walletAddress ):
    main( int(event['args']['value']))

def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        time.sleep(poll_interval)

# Infinite Loop.
panic = False
while True:
  panic = input('Did we panic?')
  balance = contractSellToken.functions.balanceOf(walletAddress).call()
  print('The current balance is: ',balance)
  if (balance > 50000000000000000000):
    event_filter = contractSellToken.events.Transfer.createFilter(fromBlock='latest')
    try:
      if panic == '1': break
      # block_filter = web3.eth.filter({"address": walletAddress})
      log_loop(event_filter, 2)
    except:
      break