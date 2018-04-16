pragma solidity ^0.4.11;

/**
 * @title tokenSpender
 * @author remi.burgel@b2expand.com
 */
contract tokenSpender {
	/**
	 * This function is called whenever the contract receive a transaction
	 *
	 * @param _from					Address which sent the transaction
	 * @param _value				Number of tokens or assets sent
	 * @param _token				Type of tokens or asset sent
	 * @param _extraData			c.f. BlackMarket.sol receiveApproval()
	 */
	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
}
