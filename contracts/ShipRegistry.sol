pragma solidity ^0.4.19;

import "./GameResolver.sol";
import "./INexium.sol";
import "./IShipRegistry.sol";


contract ShipRegistry is IShipRegistry {
    
    address public administrator;
    GameResolver public gameResolver;
    uint16 public weaponCount;
    uint256 public weaponPrice = 10000;
    INexium public nexium;
    
    
    mapping (uint16 => Weapon) public weapons;
    mapping (uint16 => mapping (uint16 => uint8)) public weaponEfficiencies;
    mapping (address => Ship) public ships;
    mapping (address => mapping (uint16 => bool)) public unlockedWeapons;
    
    function ShipRegistry(address nexiumAddress) public {
        administrator = msg.sender;
        nexium = INexium(nexiumAddress);
    }

    
    modifier adminFunction(){
        require(msg.sender == administrator);
        _;
    }
    
    function changeAdmin(address newAdmin) public 
    adminFunction(){
        administrator = newAdmin;
    }
    
    function addWeapon(string name, bytes32 pictureHash, uint8[] efficiencies) public
    adminFunction(){
        require(efficiencies.length == weaponCount + 1);
        require(efficiencies[weaponCount] == 1);
        weapons[weaponCount] = Weapon(pictureHash, name);
        for (uint16 i; i < efficiencies.length; i++){
            weaponEfficiencies[i][weaponCount] = 2 - efficiencies[i];
            weaponEfficiencies[weaponCount][i] = efficiencies[i];
        }
        weaponCount++;
    }
    
    function setWeaponsPrice(uint256 price) public
    adminFunction(){
        weaponPrice = price;
    }
    
    function setGameResolver(address newGameResolver) public
    adminFunction(){
        gameResolver = GameResolver(newGameResolver);
    }
    
    
    function levelUp() public {
        require(gameResolver.passLevel(msg.sender));
        ships[msg.sender].level++;
    }
    
    function claimFirstWeapons() public {
        unlockedWeapons[msg.sender][0] = unlockedWeapons[msg.sender][1] = unlockedWeapons[msg.sender][2] = true;
    }
    
    function receiveApproval(address _from, uint _value, address, bytes _extraData) public {
        require(_value == weaponPrice);
        require(nexium.transferFrom(_from, administrator, _value));
        uint16 weaponBought = uint16(_extraData[0]) * 256 + uint16(_extraData[1]);
        require(weaponBought < weaponCount && !unlockedWeapons[_from][weaponBought]);
        unlockedWeapons[_from][weaponBought] = true;
    }
    
    function getLevel(address user) public view returns(uint8 level){
        return ships[user].level;
    }
}