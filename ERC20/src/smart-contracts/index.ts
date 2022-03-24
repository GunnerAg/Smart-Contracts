import contractJson from './build/WickeDrive.json'

const networkId = Object.keys(contractJson.networks)[0]
console.log('NETWORK ID  ----->>>', networkId)

const contract = {
  abi: contractJson.abi,
  address: contractJson.networks[networkId].address
};

function details (){
  return contract
}