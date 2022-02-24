const main = async () => {
    //const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'), // give the contract some ether
    });
    await waveContract.deployed();

    console.log("Contract Deployed to: ", waveContract.address);
    //console.log("Contract Deployed by: ", owner.address);

    // get the contract balance
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract Balance: ',
        hre.ethers.utils.formatEther(contractBalance)
    );

    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    // let us send 2 waves
    let waveTxn = await waveContract.wave('A Message!');
    await waveTxn.wait();

    /*
    let waveTxn2 = await waveContract.wave('A Message!');
    await waveTxn2.wait();

    // get the contract balance after a wave
    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract Balance: ',
        hre.ethers.utils.formatEther(contractBalance)
    );
    */

    const [_, randomPerson] = await hre.ethers.getSigners();
    waveTxn = await waveContract.connect(randomPerson).wave('A message from randomPerson');
    await waveTxn.wait();

    // get the contract balance after a wave
    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract Balance: ',
        hre.ethers.utils.formatEther(contractBalance)
    );

    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
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