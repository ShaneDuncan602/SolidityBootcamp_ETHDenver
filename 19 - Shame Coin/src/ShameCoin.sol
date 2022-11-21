// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "openzeppelin-contracts/access/Ownable.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

/**
 * @title ShameCoin - The ultimate measure of shameful actions
 * @author @ShaneDuncan602
 * @notice Lesson 19 of ETHDenver
 * @dev This contract is only for educational purposes
 *
 */
contract ShameCoin is Ownable, ERC20 {
    /// @notice Accepts address of the owner
    /// @param _adminAddress Address of the contract owner
    constructor(address _adminAddress) ERC20("ShameCoin", "SHAME") {
        _transferOwnership(_adminAddress);
        _mint(_adminAddress, 10000);
    }

    /// @dev decimals is overridden to ensure that there are 0 decimal places.
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    /**
     * @dev Overrides standard transfer function in order to restrict to admin and only allow 1 to be sent
     *
     * @return bool value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount)
        public
        override
        returns (bool)
    {
        require(amount == 1, "Can only send one token at a time");
        if (msg.sender != owner()) {
            punish();
            return false;
        }
        _transfer(owner(), to, amount);
        return true;
    }

    /**
     * @notice You may not transfer more than 1 token at a time
     * @dev Overrides standard transfer function in order to restrict to admin and only allow 1 to be sent
     *
     * @return bool value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(amount == 1, "Can only send one token at a time");
        if (msg.sender != owner()) {
            punish();
            return false;
        }
        return super.transferFrom(from, to, amount);
    }

    /**
     * @notice You may not approve more than 1 token at a time
     * @return bool value indicating whether the operation succeeded.
     */
    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        require(amount == 1, "May only approve transfer of 1 token");
        require(spender == owner(), "May only approve admin to do transfer");
        return super.approve(spender, amount);
    }

    /**
     * @notice You may not increaseAllowance more than 1 token at a time
     * @return bool value indicating whether the operation succeeded.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        override
        returns (bool)
    {
        require(addedValue == 1, "May only allow spending of one token");
        require(spender == owner(), "May only approve admin to do transfer");
        return super.increaseAllowance(spender, addedValue);
    }

    /// @dev  This function "punishes" by adding a shame coin to the sender.
    function punish() private {
        _transfer(owner(), msg.sender, 1);
    }
}
