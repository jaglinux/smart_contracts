pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

interface IBaseContract {
    struct Constraint {
        uint256 maxAmountPerShot;
        uint256 snapShot;
        uint256 amountIn;
    }
    function checkRolePermission(address _scwAddress, bytes4 _role) external returns(bool);
    function getConstraint(address _scwAddress, bytes4 _role) external returns(Constraint[] memory);
}

interface IUniswap {
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address) external returns (uint256);
}

contract WalletImplementation {
    bool public init;
    address public base;
    mapping(address => bool) public auth;
    address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    event LiquidityAdded(address, uint, uint, uint);
    event log(string);

    // Auth mapping is present in this contract itself.
    modifier checkAuth() {
        require(auth[msg.sender] == true, "Not Authorized");
        _;
    }

    //RolePermission mapping is present in base (factory) contract.
    modifier checkRolePermission() {
        require(IBaseContract(base).checkRolePermission(address(this), msg.sig) == true, 
            "No Permission granted");
        _;
    }

    function initializer(address _base, address _owner) external {
        require(init == false, "Already initialized");
        base = _base;
        auth[_owner] = true;
        init = true;
    }

    // Smart contract wallets can be controlled by multiple parties.
    // ToDo: Add removeGuardian function. Its tricky !
    // What if the secondary guardian removes the primary signer itself ???
    // ToDo: Add functions to withdraw Eth and token. Similar problem as above.
    function addGuardian(address _guardian) external checkAuth() {
        auth[_guardian] = true;
    }

    // function signature 0xd7e4b152
    // This code shouuld be present in seperate contract.
    // Fallback function will delegate the call according to msg.sig
    // Check fallback functions below for more details.
    // ******** This code is not tested *****************
    function actionUniswapAddLiquidity(
        address token,
        uint[] memory amounts
        ) external payable checkAuth() checkRolePermission() {
        
        IBaseContract.Constraint[] memory constraints = IBaseContract(base).getConstraint(address(this), msg.sig);
        
        uint256 len = constraints.length;
        // Assuming Eth is the first index into constraints array
        for(uint256 i; i <= len;) {
            if (block.timestamp <= constraints[i].snapShot) {
                if (constraints[i].amountIn >= constraints[i].maxAmountPerShot) {
                    // Already utilized maximum allocation
                    return;
                }
                uint256 amountInPending = constraints[i].maxAmountPerShot - constraints[i].amountIn;
                // Can accomadate only maxAmountPerShot
                amounts[0] = (amounts[0] > amountInPending ? amountInPending:amounts[0]);
                // Todo: Update amountIn in base contract.
            } else {
                // Reset the snapshot
                // Todo: Update snapShot to block.timestamp and amountIn to 0 in base contract
            }

            unchecked {
                ++i;
            }
        }
        require(amounts[1] <= IERC20(token).balanceOf(address(this)), "not enough token balance");
        require(amounts[0] <= address(this).balance, "not enough eth balance");

        IERC20(token).approve(UNISWAP_ROUTER_ADDRESS, amounts[1]);
        (uint amountToken, uint amountETH, uint liquidity) = 
        IUniswap(UNISWAP_ROUTER_ADDRESS).addLiquidityETH{ value: amounts[0] } (
            token, amounts[1], amounts[1], amounts[0], address(this), block.timestamp + 100);
        emit LiquidityAdded(address(this), amountToken, amountETH, liquidity);
    }

    // Generic code to call contract with abi enocded signatures and params.
    // ToDo: All actions should be called by respective protocol interface contracts.
    // This function is not used as of now.
    // ToDo: Make this external after checking validating permission.
    function actions(address[] memory _targets, bytes[] memory _datas, uint256[] memory _values) 
        internal {
        for (uint i = 0; i < _targets.length; i++) {
            execute(_targets[i], _datas[i], _values[i]);
        }
    }
    
    function execute(address _target, bytes memory _data, uint256 _value) internal {
        require(_target != address(0), "target contract cannot be zero address");
        assembly {
            let result := call(gas(), _target, _value, add(_data, 0x20), mload(_data), 0, 0)

            switch iszero(result)
                case 1 {
                    let size := returndatasize()
                    returndatacopy(0x00, 0x00, size)
                    revert(0x00, size)
            }
        }
    }
    function _fallback() internal {
        // Ideally all implementations such as actionUniswapAddLiquidity should be in respective 
        // protocol interface contracts. We just need to delegate all calls to respective interface
        // contracts.

        // EXAMPLE code
        //address implementation = implementations.getImplementation(msg.sig);
        //_delegate(_implementation);
    }

    fallback () external payable {
        _fallback();
    }


    receive () external payable {
        _fallback();
    }
}
