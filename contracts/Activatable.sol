// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Activatable is Ownable {
  event Deactivate(address indexed _sender);
  event Activate(address indexed _sender);

  bool public activate = false;

  modifier whenActive() {
    require(active);
    _;
  }

  modifier whenNotActive() {
    require(!active);
    _;
  }

  function deactive() public whenActive onlyOwner {
    active = false;
    emit Deactivate(msg.sender);
  }

  function activate() public whenNotActive onlyOwner {
    active = true;
    emit Activate(msg.sender);
  }
}