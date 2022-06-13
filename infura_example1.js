const Web3 = require('web3')
const fs = require('fs')

// Creates an instance of the web3 module/library

// QUERY THE LATEST BLOCK NUMBER; ALL THE TRANSACTIONS IN THE BLOCK; AND PENDING TRANSACTIONS

let web3 = new Web3(
  new Web3.providers.WebsocketProvider(
    `wss://mainnet.infura.io/ws/v3/<insert your own infura node ID>`,
  ),
)

web3.eth.getBlockNumber().then((result) => {
  console.log('Latest Ethereum Block is ', result)
})


  web3.eth.getBlock(result)
  .then(console.log);

var subscription = web3.eth
  .subscribe('pendingTransactions', function (error, result) {})

  .on('data', function (transaction) {
    console.log(transaction)

    let data = JSON.stringify(transaction)

    fs.writeFile('/Users/---/TRANSACTIONS.txt', transaction, err => {
      if (err) {
        console.error(err);
      }
      // file written successfully
    });
    

    web3.eth.getTransaction(transaction).then((response) =>
      // write the transaction data to a file utilizing the fs Module/Library
      console.log(`${transaction}: ${JSON.stringify(response)}`),
    )
  })

