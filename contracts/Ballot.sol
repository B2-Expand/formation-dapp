pragma solidity ^0.4.19;

import "./IShipRegistry.sol";
import "./INexium.sol";

contract Ballot {
    
    uint8 ERROR_PROPOSAL = 0;
    uint8 CHANGE_SHIPRegistry = 1;
    uint8 CHANGE_BALLOT = 2;
    uint8 CHANGE_PROPOSALTIME = 3;
    uint8 CHANGE_GAMERESOLVER = 4;
    uint8 NEW_WEAPON = 5;
    uint8 CHANGE_WEAPONPRICE = 6;
    
    
    IShipRegistry public shipRegistry;
    INexium public nexium;
    uint32 public proposalTime = 1 weeks;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) voted; // Peut tout de même être vu !
    mapping(uint256 => Weapon) public proposedWeapons;
    uint256 public proposalAmount;
    uint256 public weaponAmount;
    
    struct Weapon {
        bytes32 pictureHash;
        string name;
        bytes efficiencies;
    }
    
    struct Proposal {
        address proposer;
        uint8 propType;
        string quickDesc;
        bytes32 extraData;
        uint votesFor;
        uint votesAgainst;
        uint endDate;
        bool resultApplied;
    }
    
    function Ballot(address shipRegistryAddress, address nexiumAddress) public {
        shipRegistry = IShipRegistry(shipRegistryAddress);
        nexium = INexium(nexiumAddress);
    }
    
    function resolveProposal(uint256 proposalId) public {
        Proposal storage prop = proposals[proposalId];
        require(prop.proposer != 0x0 && !prop.resultApplied && now > prop.endDate);
        if (prop.votesFor > prop.votesAgainst){
            nexium.transfer(prop.proposer, nexium.balanceOf(this) / 2);
            if(prop.propType == ERROR_PROPOSAL)
                revert();
                
            else if (prop.propType == CHANGE_SHIPRegistry){
                shipRegistry = IShipRegistry(address(prop.extraData));
                
            } else if (prop.propType == CHANGE_BALLOT){
                shipRegistry.changeAdmin(address(prop.extraData));
                nexium.transfer(address(prop.extraData), nexium.balanceOf(this)/2);
                
            } else if (prop.propType == CHANGE_PROPOSALTIME){
                proposalTime = uint32(prop.extraData);
                
            } else if (prop.propType == CHANGE_GAMERESOLVER){
                shipRegistry.setGameResolver(address(prop.extraData));
                
            } else if (prop.propType == NEW_WEAPON){
                Weapon memory weapon = proposedWeapons[uint256(prop.extraData)];
                uint8[] memory efficiencies = new uint8[](weapon.efficiencies.length);
                uint256 i = 0;
                for(i; i< weapon.efficiencies.length; i++){
                    efficiencies[i] = uint8(weapon.efficiencies[i]);
                }
                shipRegistry.addWeapon(weapon.name, weapon.pictureHash, efficiencies);
            } else if (prop.propType == CHANGE_WEAPONPRICE){
                shipRegistry.setWeaponsPrice(uint256(prop.extraData));
            } else revert();
        } else {
            prop.resultApplied = true;
        }
    }
    
    function propose(uint8 propType, string quickDesc, bytes32 extraData) public{
        require(shipRegistry.getLevel(msg.sender) >= 10);
        
        proposals[proposalAmount] = 
            Proposal(
                msg.sender,
                propType,
                quickDesc,
                extraData,
                1,
                0,
                now + proposalTime,
                false
            );
        voted[proposalAmount][msg.sender] = true;
        proposalAmount++;
    }
    
    function proposeWeapon(string name, bytes32 pictureHash, bytes efficiencies) public {
        proposedWeapons[weaponAmount++] = Weapon(pictureHash, name,  efficiencies);
    }
    
    function vote(uint256 proposalId, bool agree) public {
        Proposal storage prop = proposals[proposalId];
        require (shipRegistry.getLevel(msg.sender) >= 10 && now < prop.endDate && !voted[proposalId][msg.sender]);
        voted[proposalId][msg.sender] = true;
        if(agree) prop.votesFor++;
        else prop.votesAgainst++;
    }
    
}