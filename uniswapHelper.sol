// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IRouter {
    function WETH() external pure returns (address);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IERC20 {
    function transferFrom(address, address, uint) external;
    function approve(address, uint) external;
}
contract UniSwapHelper {
    address public constant UniswapV2Router02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public immutable WETH;
    address public constant USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;

    constructor() {
        WETH = IRouter(UniswapV2Router02).WETH();
    }

    function swapTokens(uint256 _usdcAmount, uint256 _wethAmount) 
        external returns (uint[] memory amounts) {
        IERC20(USDC).transferFrom(msg.sender, address(this), _usdcAmount);
        IERC20(USDC).approve(UniswapV2Router02, _usdcAmount);
        address[] memory path = new address[](2);
        path[0] = USDC;
        path[1] = WETH;
        return IRouter(UniswapV2Router02).swapExactTokensForTokens(_usdcAmount, _wethAmount,
            path, msg.sender, block.timestamp);
    }
}
