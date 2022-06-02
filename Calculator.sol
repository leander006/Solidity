// SPDX-License-Identifier: GPL-3.0\

pragma solidity >=0.5.0 < 0.9.0;

contract cal
{
    int public num;

    function setAdd(int num1,int num2) public
    {
        num = num1 + num2;
    }

    function setSub(int num1,int num2) public
    {
        num = num1 - num2;
    }

    function setMul(int num1,int num2) public
    {
        num = num1 * num2;
    }
}