pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

interface IWalletImplementation {
    function initializer(address _base, address _owner) external;
}

contract Base {
    struct Constraint {
        uint256 maxAmountPerShot;
        // only maxAmountPerShot can be sent till expiry of snapShot
        // example: 1 eth per day.
        // maxAmountPerShot will be 1 eth
        uint256 snapShot;
        // After snapshot expiry, amountIn is set to 0
        uint256 amountIn;
    }
    struct ConstraintParam {
        uint256 snapShotDuration;
        uint256 maxAmountPerShot;
    }
    struct RoleConstraint {
        bool permission;
        Constraint[] constraint;
    }
    // impl => Smart Contract Implementation address
    address public impl;
    // Permission to add roles and admin access
    // 2 keys allowed : "admin" and "addRole"
    mapping(string => mapping(address => bool)) public adminRolesPermission;
    // Mapping of SmartContractWallet address to roles
    // Roles are determined by function signature (msg.sig)
    // Note: SmartContractWallet address is different from SmartContractWallet owner address
    // ToDo: Can we move this mapping inside respective Wallet Implementation ?
    mapping(bytes4 => mapping(address => RoleConstraint)) public roleToUserPermission;

    event newImpl(address newImpl, address oldImpl);
    event newSCW(address);

    modifier checkAddAdminRolesPerm(string memory _role) {
        require(adminRolesPermission[_role][msg.sender] == true, "No Permission granted");
        _;
    }

    // Change Wallet implementation
    function changeImpl(address _newImpl) external checkAddAdminRolesPerm("admin") {
        address oldImpl = impl;
        impl = _newImpl;
        emit newImpl(_newImpl, oldImpl);
    }

    function addAdminRolesPermission(address _user, string memory _role) external checkAddAdminRolesPerm(_role) {
        adminRolesPermission[_role][_user] = true;
    }

    // Assume Eth as the only index in Constraint, tricky to apply same rules to tokens
    // since it affects the lp balance, need to study further. 
    // *******Constraint code is not tested*******
    function addRoles(address _scwAddress, bytes4 _role, ConstraintParam[] memory _constraintsParam) external 
        checkAddAdminRolesPerm("addRole") {
        roleToUserPermission[_role][_scwAddress].permission = true;
        uint256 len = _constraintsParam.length;
        for(uint256 i; i <= len;) {
            Constraint memory temp = Constraint({
                maxAmountPerShot:_constraintsParam[i].maxAmountPerShot, 
                snapShot: block.timestamp + _constraintsParam[i].snapShotDuration, 
                amountIn:0});
            roleToUserPermission[_role][_scwAddress].constraint.push(temp);
            unchecked {
                ++i;
            }
        }
    }

    function getConstraint(address _scwAddress, bytes4 _role) external view returns(Constraint[] memory) {
        return roleToUserPermission[_role][_scwAddress].constraint;
    }

    function checkRolePermission(address _scwAddress, bytes4 _role) external view returns (bool) {
        return roleToUserPermission[_role][_scwAddress].permission;
    }
}

contract SmartContractWalletFactory is Base {
    function CreateSCW() internal returns (address result) {
        bytes20 implBytes = bytes20(impl);
        // Minimal Proxy Contracts (EIP-1167)
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), implBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }
}

contract SmartContractWallet is SmartContractWalletFactory {

    constructor() {
        adminRolesPermission["admin"][msg.sender] = true;
        adminRolesPermission["addRole"][msg.sender] = true;
    }

    function _createWallet(address _owner) internal returns(address newWallet) {
        newWallet = CreateSCW();
        // called only once.
        // Pass the base contract address to access checkRolePermission and getConstraint
        // This can be in seperate contract address space.
        IWalletImplementation(newWallet).initializer(address(this), _owner);
        emit newSCW(newWallet);
    }

    // Owner of wallet is msg.sender
    function createWallet() external returns(address newWallet) {
        return _createWallet(msg.sender);
    }

    // Owner of wallet is different than msg.sender, _owner controls the wallet.
    function createWallet(address _owner) external returns(address newWallet) {
        return _createWallet(_owner);
    }
}
