// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import 'openzeppelin-solidity/contracts/lifecycle/Destructible.sol';
import './Activatable.sol';

contract Room is Destructible, Pausable, Activatable {
  // sendReward関数を実行する際の二重支払いの防止のため
  mapping (uint256 => bool) public rewardSent;

  event Deposited (
    address indexed _depositor,
    uint256 _depositedValue
  );

  event RewardSent (
    address indexed _dest,
    uint256 _reward,
    uint256 _id
  );

  event RefundedToOwner (
    address indexed _dest,
    uint256 _refundedBalance
  );

  constructor(address _creator) public payable {
    owner = _creator;
  }

  function deposit() external payable whenNotPaused {
    require(msg.value  > 0);

    emit Deposited(msg.sender, msg.value);
  }

  function sendReward(uint256 _reward, address _dest, uint256 _id) external onlyOwner {
    require(!rewardSent[_id]);
    require(_reward > 0);
    require(address(this).balance >= _reward);
    require(_dest != address(0));
    require(_dest != owner);

    rewardSent[_id] = true;
    _dest.transfer(_reward);
    emit RewardSent(_dest, _reward, _id);
  }

  // ルームオーナーへの全額返金はルームが非活性の時のみ実行させたいため
  function refundToOwner() external whenNotActive onlyOwner {
    require(address(this).balance > 0);

    uint256 refundedBalance = address(this).balance;
    owner.transfer(refundedBalance);
    emit RefundedToOwner(msg.sender, refundedBalance);
  }
}