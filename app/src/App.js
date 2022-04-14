import React, { useEffect, useState } from "react";
import './styles/App.css';
import twitterLogo from './assets/twitter-logo.svg';
import manSplainTweet from './assets/siriTweet.jpg';
import { ethers } from "ethers";
import MansplainNft from "./utils/MansplainNft.json";

// Constants
const TWITTER_HANDLE = 'KyleLackinger';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = 'https://testnets.opensea.io/collection/let-me-mansplain-that-f0jolkuoi8';
const TOTAL_MINT_COUNT = 20;
const CONTRACT_ADDRESS = '0x856A689A50Be60242009A10F5EaE3f9F5D64a374';

const App = () => {
  // State variables
  const [currentAccount, setCurrentAccount] = useState("");
  const [nftCount, setNftCount] = useState("");
  
  const checkIfWalletIsConnected = async () => {
    // Check for access to window.ethereum
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have MetaMask extension installed");
      return;
    } else {
      console.log("Ethereum object present", ethereum);
    }

    // Check if authorized to access the user's wallet
    const accounts = await ethereum.request({ method: 'eth_accounts' });

    // Grab the first account
    if (accounts.lenght !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
      setUpEventListener();
    } else {
      console.log("No account authorized");
    }
  }

  // Implement connecWallet method
  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Install MetaMask extension");
        return;
      }

      // Request access to account
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });

      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
      setUpEventListener();
    } catch (error) {
      console.error(error);
    }
  }

  const setUpEventListener = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, MansplainNft.abi, signer);

        connectedContract.on("nftMinted", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          alert(`Your Playing Card has been minted and sent to your wallet. Here's the link on OpenSea: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}.`)
        });

        console.log("Setup event listener")
      } else {
        console.log("Ethereum object does not exist")
      }
    } catch (error) {
      console.log(error);
    }
  }

  const askContractToMintNft = async () => {
    

    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, MansplainNft.abi, signer);

        console.log("Pop wallet to pay gas")
        let txn = await connectedContract.makeNFT();

        console.log("Mining");
        await txn.wait();

        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${txn.hash}`);

        txn = await connectedContract.getTotalNftsMintedSoFar();

        console.log(`There are ${txn} Playing Cards minted so far.`)
        setNftCount(txn.toNumber().toString());
      } else {
        console.log("Ethereum object does not exist");
      }
    } catch (error) {
      console.log(error);
    }
  }
  
// useEffect runs the function to check if wallet is connected when
  // the page loads
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

  // Render Methods
  const renderNotConnectedContainer = () => (
    <div>
      <button onClick={connectWallet} className="cta-button connect-wallet-button">
        Connect to Wallet
      </button>
      <p className="links">
        <a href='https://testnets.opensea.io/collection/let-me-mansplain-that-f0jolkuoi8'>LMMT on OpenSea</a>
      </p>
    </div>
  );

  const renderMintUI = () => (
    <div className='header-container'>
      <button onClick={askContractToMintNft} className='cta-button mint-button'>
        Mint NFT
      </button>
      <p className="links">
        <a href='https://testnets.opensea.io/collection/let-me-mansplain-that-f0jolkuoi8'>LMMT on OpenSea</a>
      </p>
    </div>
  );

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">Let Me Mansplain That</p>
          <p className="sub-text">
            <em>Mansplaining</em>: a pejorative term meaning to comment on or explain something to a woman in a condescending, overconfident, and often inaccurate or oversimplified way.
          </p>
          <img alt="Funny Mansplain Tweet" className="tweet-pic" src={manSplainTweet} />
          <p className="sub-text">
            Mansplaining can occur when you'd least expect it, when you expect it the most, or pretty much any other time.
          </p>
          <p className="sub-text">
            
          </p>
          <p className="sub-text">{nftCount} / {TOTAL_MINT_COUNT} Playing Cards Claimed!</p>
          {!currentAccount ? (
            renderNotConnectedContainer()
          ) : (
            renderMintUI()
          )}
        </div>
        <div className="col-container">
          <h2 className="rule-text">LMMT Rules</h2>
          <div className="split extra-space">
            <div className="col">
              <h3>1. Getting Started</h3>
              <p>Get 4 people together that like to laugh 😂. That doesn't seem too hard...</p>
            </div>
            <div className="col">
              <h3>2. Play a few Round</h3>
              <p>Draw a <span className="green">Scenario Card</span>. Choose the <span className="pink">Response card</span> that makes the person that is up lol the hardest.</p>
            </div>
            <div className="col">
              <h3>3. Keeping Score</h3>
              <p>Whoever succeeds in causing the most lols wins. Everyone really wins.</p>
            </div>
          </div>
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built by @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};

export default App;
