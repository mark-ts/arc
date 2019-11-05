pragma solidity ^0.5.11;

import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";


/**
 * @title reputation allocation contract
 * This scheme can be used to allocate a pre define amount of reputation to whitelisted
 * beneficiaries.
 * this contract can be used as the rep mapping contract for  RepitationFromToken contract.
 */
contract RepAllocation is Initializable, Ownable {


       // beneficiary -> amount
    mapping(address   =>   uint256) public reputationAllocations;
    bool public isFreeze;

    event BeneficiaryAddressAdded(address indexed _beneficiary, uint256 indexed _amount);

    /**
    * @dev initialize function
    * @param _owner contract's owner to be set
    */
    function initialize(address _owner) public initializer {
        Ownable.initialize(_owner);
    }

    /**
     * @dev addBeneficiary function
     * @param _beneficiary to be whitelisted
     */
    function addBeneficiary(address _beneficiary, uint256 _amount) public onlyOwner {
        require(!isFreeze, "can add beneficiary only if not disable");

        if (reputationAllocations[_beneficiary] == 0) {
            reputationAllocations[_beneficiary] = _amount;
            emit BeneficiaryAddressAdded(_beneficiary, _amount);
        }
    }

    /**
     * @dev add addBeneficiaries function
     * @param _beneficiaries addresses
     */
    function addBeneficiaries(address[] memory _beneficiaries, uint256[] memory _amounts) public onlyOwner {
        require(_beneficiaries.length == _amounts.length);
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            addBeneficiary(_beneficiaries[i], _amounts[i]);
        }
    }

    /**
     * @dev freeze function
     * cannot defreeze
     */
    function freeze() public onlyOwner {
        isFreeze = true;
    }

    /**
     * @dev get balanceOf _beneficiary function
     * @param _beneficiary addresses
     */
    function balanceOf(address _beneficiary) public view returns(uint256) {
        return reputationAllocations[_beneficiary];
    }

}