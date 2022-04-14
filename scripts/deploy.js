const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MansplainNft');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    // Call mint function
    let txn = await nftContract.makeNFT()
    // Wait to mine
    await txn.wait()
    console.log("Minted NFT 01")

};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();