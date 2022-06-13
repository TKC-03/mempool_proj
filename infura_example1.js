const Web3 = require('web3')
const fs = require('fs')

// Creates an instance of the web3 module/library

let web3 = new Web3(
  new Web3.providers.WebsocketProvider(
    `wss://mainnet.infura.io/ws/v3/073da3011a37435a926c6adecdf0e9e5`,
  ),
)

web3.eth.getBlockNumber().then((result) => {
  console.log('Latest Ethereum Block is ', result)
})

// subscribe() method takes Two Parameters/Arguments

// First parameter/argument is the string; Second Parameter/Argument is the call back function

var subscription = web3.eth
  .subscribe('pendingTransactions', function (error, result) {})

  // on() method

  // write the transaction data to a file utilizing the fs Module/Library
  .on('data', function (transaction) {
    console.log(transaction)

    let data = JSON.stringify(transaction)

    // fs.writeFileSync('transaction_hashes.json', transaction)


    // successfully saved One Transaction Hash to a file; in this case a .txt file
    fs.writeFile('/Users/dok92/test.txt', transaction, err => {
      if (err) {
        console.error(err);
      }
      // file written successfully
    });
    
    

    // THIS IS A PROMISE ; A PROMISE IS AN OBJECT THAT RETURNS A VALUE ;IT CAN EITHER RESOLVE OR REJECT, AND YOU CAN ATTACH A CALLBACK FUNCTION TO EITHER PATH

    web3.eth.getTransaction(transaction).then((response) =>
      // write the transaction data to a file utilizing the fs Module/Library
      console.log(`${transaction}: ${JSON.stringify(response)}`),
    )
  })

  web3.eth.getBlock(14953570)
  .then(console.log);

  
//web3.eth.getPendingTransactions().then((result) => {
//  console.log('pending transactions are ', result)
// })

 // var receipt = web3.eth.getTransactionReceipt('0xaa6ef2bd4ab5d5b63e4282831b8c728a6095c8eb1c71223f2c020b082664f523')
 // .then(console.log(receipt));

// GO THROUGH ALL THE PENDING TX'S AND ANY NOTABLE/REMARKABLE TXS WITH FLASH LOAN ARBITRAGE; FLASH LOAN USAGE
