// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './Room.sol';

contract RoomFactory {
  function createRoom() external payable {
    // コンストラクタによるインスタンス生成と送金を同時に行う場合は
    // (new コントラクト).value(送金額)(コンストラクタの引数)
    address newRoom = (new Room).value(msg.value)(msg.sender);
  }
}