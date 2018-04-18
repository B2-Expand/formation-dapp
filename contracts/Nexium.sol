pragma solidity ^0.4.1;
contract tokenSpender { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

contract Nexium {
	/* Public variables of the token */
	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public initialSupply;
	address public burnAddress = 0x1B32000000000000000000000000000000000000;

	/* This creates an array with all balances */
	mapping (address => uint) public balanceOf;
	mapping (address => mapping (address => uint)) public allowance;

	/* This generates a public event on the blockchain that will notify clients */
	event Transfer(address indexed from, address indexed to, uint value);
	event Approval(address indexed from, address indexed spender, uint value);



	/* Initializes contract with initial supply tokens to the creator of the contract */
	function Nexium() public {
		initialSupply = 100000000000;
		balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens
		name = 'Nexium';                                 // Set the name for display purposes
		symbol = 'NxC';                               	 // Set the symbol for display purposes
		decimals = 3;                           		 // Amount of decimals for display purposes
	}

	function totalSupply() public view returns(uint){
		return initialSupply - balanceOf[burnAddress];
	}

	/* Send coins */
	function transfer(address _to, uint256 _value) public
	returns (bool success) {
		if (balanceOf[msg.sender] >= _value && _value > 0) {
			balanceOf[msg.sender] -= _value;
			balanceOf[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		} else return false;
	}

	/* Allow another contract to spend some tokens in your behalf */



	function approveAndCall(address _spender,
							uint256 _value,
							bytes _extraData)
	public
	returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		tokenSpender spender = tokenSpender(_spender);
		spender.receiveApproval(msg.sender, _value, this, _extraData);
		Approval(msg.sender, _spender, _value);
		return true;
	}



	/*Allow another adress to use your money but doesn't notify it*/
	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}


	/* A contract attempts to get the coins */
	function transferFrom(address _from,
						  address _to,
						  uint256 _value)
	public
	returns (bool success) {
		if (balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value && _value > 0) {
			balanceOf[_to] += _value;
			Transfer(_from, _to, _value);
			balanceOf[_from] -= _value;
			allowance[_from][msg.sender] -= _value;
			return true;
		} else return false;
	}

}
