pragma solidity ^0.4.19;

import "./GameResolver.sol";
import "./INexium.sol";


contract IShipRegistry {
    
    address public administrator;
    GameResolver public gameResolver;
    uint16 public weaponCount;
    uint256 public weaponPrice;
    INexium public nexium;
    
    
    struct Weapon {
        bytes32 pictureHash;
        string name;
    }
    
    struct Ship {
        uint16[3] slots;
        string name;
        uint8 level;
    }
    
    mapping (uint16 => Weapon) public weapons;
    mapping (uint16 => mapping (uint16 => uint8)) public weaponEfficiencies;
    mapping (address => Ship) public ships;
    mapping (address => mapping (uint16 => bool)) public unlockedWeapons;
    
    function changeAdmin(address newAdmin) public;
    function addWeapon(string name, bytes32 pictureHash, uint8[] efficiencies) public;
    function setWeaponsPrice(uint256 price) public;
    function levelUp() public;
    function claimFirstWeapons() public;
    function receiveApproval(address _from, uint _value, address, bytes _extraData) public;
    function getLevel(address user) public view returns(uint8 level);
    function setGameResolver(address newGameResolver) public;
}