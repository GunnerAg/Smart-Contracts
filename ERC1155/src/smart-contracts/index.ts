import contractJson from './build/MintClubToken.json'

const networkId = Object.keys(contractJson.networks)[0]

export default {
  abi: contractJson.abi,
  address: contractJson.networks[networkId].address
}
