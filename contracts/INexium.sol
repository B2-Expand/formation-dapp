pragma solidity ^0.4.1;
import "./tokenSpender.sol";
contract INexium {
	/* Public variables of the token */
	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public initialSupply;
	address public burnAddress;

	/* This creates an array with all balances */
	mapping (address => uint) public balanceOf;
	mapping (address => mapping (address => uint)) public allowance;

	/* This generates a public event on the blockchain that will notify clients */
	event Transfer(address indexed from, address indexed to, uint value);
	event Approval(address indexed from, address indexed spender, uint value);

	function totalSupply() public view returns(uint);

	/* Send coins */
	function transfer(address _to, uint256 _value) public
	returns (bool success) ;

	/* Allow another contract to spend some tokens in your behalf */



	function approveAndCall(address _spender,
							uint256 _value,
							bytes _extraData)
	public
	returns (bool success) ;



	/*Allow another adress to use your money but doesn't notify it*/
	function approve(address _spender, uint256 _value) public returns (bool success) ;



	/* A contract attempts to get the coins */
	function transferFrom(address _from,
						  address _to,
						  uint256 _value)
	public
	returns (bool success) ;

}
