// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract VerifierTest is Test {
    IVerifier verifier;

    function setUp() public {
        bytes memory bytecode =
            abi.encodePacked(vm.getCode("Verifier.sol:Verifier"));
        address verifierAddress;
        assembly {
            verifierAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        verifier = IVerifier(verifierAddress);
    }

    function test() public {
        // 3 * 11 = 33
        // from `snarkjs generatecall`
        uint256[2] memory a = [
            0x2e3bea5d5328e4ed408e14dc4ed6ad4f01c753c4b727718433dc3e8ec3b4e9d2,
            0x0fa9e70a41e712d37045867aa3036813566e472e3f9d5e3a385bd160b34e8314
        ];
        uint256[2][2] memory b = [
            [
                0x1c318373d4fbf2ef99607ed38c0708f74f216a54132df7e693a61c862687feb9,
                0x192c52f1792a147f51932ef2bac26f481f6715e37631638bc06bc30bacb1639b
            ],
            [
                0x0dcab7d7727aba6021c5c6a160729d792a0f0bfa024da8e89f72ebd044af8edd,
                0x12ec930d6f71a999b28244bb72f6e374f71de4158748ef392f726e2ef9acbe1f
            ]
        ];
        uint256[2] memory c = [
            0x1ec7b43b9230dc79c0b13a0910ac2400b746b203731b826f2535e2ce38efb0e8,
            0x176d7d94074e0a1245843494b8860854836cd266d5ae64f88853ca18d698a0b1
        ];
        uint256[1] memory input = [
            uint256(0x0000000000000000000000000000000000000000000000000000000000000021)
        ];
        bool result = verifier.verifyProof(a, b, c, input);
        assertTrue(result);
    }
}

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[1] memory input
    )
        external
        view
        returns (bool r);
}
