.
pragma solidity ^0.6.6;
import "./FlashLoanReceiverBase.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";

contract FlashloanV1 is FlashLoanReceiverBaseV1 {

    // adddress for the lending pool                                 adddress of the lender
    constructor(address _addressProvider) FlashLoanReceiverBaseV1(_addressProvider) public {}

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
    
    function estimateDualDexTrade(address _router1, address _router2, address _token1, address _token2, uint256 _amount) external view returns (uint256) {
 	 uint256 amtBack1 = getAmountOutMin(_router1, _token1, _token2, _amount);
 	 uint256 amtBack2 = getAmountOutMin(_router2, _token2, _token1, amtBack1);
 	 return amtBack2;
	}

     function LookForDexArb(address _router1, address _router2, address _token1, address _token2, uint256 _amount) external onlyOwner {
         uint startBalance = IERC20(_token1).balanceOf(address(this));
         uint token2InitialBalance = IERC20(_token2).balanceOf(address(this));
         swap(_router1,_token1, _token2,_amount);
         uint token2Balance = IERC20(_token2).balanceOf(address(this));
         uint tradeableAmount = token2Balance - token2InitialBalance;
         swap(_router2,_token2, _token1,tradeableAmount);
         uint endBalance = IERC20(_token1).balanceOf(address(this));
        require(endBalance > startBalance, "Trade Reverted, No Profit Made");
     }


     function swap(address router, address _tokenIn, address _tokenOut, uint256 _amount) private {
		IERC20(_tokenIn).approve(router, _amount);
		address[] memory path;
		path = new address[](2);
		path[0] = _tokenIn;
		path[1] = _tokenOut;
		uint deadline = block.timestamp + 300;
		IUniswapV2Router(router).swapExactTokensForTokens(_amount, 1, path, address(this), deadline);
	}


    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */

     // provide adddress of the Asset that you are borrowing from AAVE
    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;    // Going to ask for 1 ETH WORTH OF THE ASSET      18 zeros 1 ether worth of that token

        ILendingPoolV1 lendingPool = ILendingPoolV1(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}
