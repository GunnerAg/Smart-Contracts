const WickeDrive = artifacts.require("../src/smart-contracts/contracts/Wickedrive.sol");

contract("Testing WickeDrive on development", async (accounts) => {

    const [deployerAccount] = accounts;

    it('Delpoyer account intially has totalSupply()', async () => {
        const instance = await WickeDrive.deployed();
        const decimals = await instance.decimals();
        const totalSupply = await instance.totalSupply();
        const balance = await instance.balanceOf.call(deployerAccount);
        const amount = parseInt(balance)/(10**decimals);
        const supply = parseInt(totalSupply)/(10**decimals)
        assert.equal(amount.valueOf(), supply);
    });

});