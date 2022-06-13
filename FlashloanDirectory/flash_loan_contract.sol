pragma solidity ^0.6.6;
import "./FlashLoanReceiverBase.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";


// Deploy on Remix IDE on a testnet    or Use a .py Script to deploy by utilizing Brownie; 
// Brownie is a python framework for interacting with Smart Contracts on the Ethereum Decentralized Network/BlockChain/Virtual Machine


// The FlashLoanV1 contract is inheriting from the FlashLoanReceiverBaseV1 contract.
contract FlashloanV1 is FlashLoanReceiverBaseV1 {

// We passed the address of one of the Lending Pool Providers of Aave. In this case, we are providing the address of DAI Lending Pool. 
    constructor(address _addressProvider) FlashLoanReceiverBaseV1(_addressProvider) public{}

 /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */

     //  We have defined a function called flashLoan. It takes the address of the asset we want to flash loan.
     // In this case the asset is DAI.
    

    // A Function is basically an input/output; A function returns an Output
 function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;

        ILendingPoolV1 lendingPool = ILendingPoolV1(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }

    /**
  This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");
       //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

} 
