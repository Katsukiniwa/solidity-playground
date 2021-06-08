// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import 'openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'openzeppelin-solidity/contracts/lifecycle/Destructible.sol';
import './Room.sol';

contract RoomFactory is Destructible, Pausable {
  event RoomCreated(
    address indexed _creator,
    address _room,
    uint256 _depositedValue
  );

  function createRoom() external payable whenNotPaused {
    // コンストラクタによるインスタンス生成と送金を同時に行う場合は
    // (new コントラクト).value(送金額)(コンストラクタの引数)
    address newRoom = (new Room).value(msg.value)(msg.sender);
    emit RoomCreated(msg.sender, newRoom, msg.value);
  }
}