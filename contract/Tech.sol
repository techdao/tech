//SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.6.0;

import "./interface/ITech.sol";
import "./interface/IERC721.sol";
import "./lib/Counters.sol";
import "./lib/EnumerableSet.sol";
import "./lib/EnumAddressSet.sol";

contract Tech is ITech
{
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumAddressSet for EnumAddressSet.AddressSet;

    mapping(address => mapping(uint256 => Counters.Counter)) private _polls;//token->(suspectTokenId->poll)
    mapping(address => mapping(uint256 => bool)) private _voted;//token->(voteTokenId->bVoted)
    mapping(address => EnumerableSet.UintSet) private _preList;
    EnumAddressSet.AddressSet private _contrList;

    function suspectPoll(address token, uint256 suspectTokenId) external override view returns (uint256 poll){
        return _polls[token][suspectTokenId].current();
    }

    function preList(address token) external override view returns (uint256[] memory){
        return _preList[token].values();
    }

    function contrList() external override view returns (address[] memory){
        return _contrList.values();
    }

    function addNftToPreList(address token, uint256 suspectTokenId) external override returns (bool){
        require(IERC721(token).balanceOf(msg.sender) > 0, "Must own 1 NFT at least");
        require(IERC721(token).ownerOf(suspectTokenId) != address(0), "Invalid NFT");
        _contrList.add(token);
        emit OnAddNftToPreList(msg.sender, token, suspectTokenId);
        return _preList[token].add(suspectTokenId);
    }

    function suspectVoteBatch(address token, uint256[] calldata voteTokenIds, uint256 suspectTokenId) external override returns (bool){
        for (uint i = 0; i < voteTokenIds.length; i++) {
            _suspectVote(token, voteTokenIds[i], suspectTokenId);
        }
        emit OnSuspectVoteBatch(msg.sender, token, voteTokenIds, suspectTokenId);
        return true;
    }

    function suspectVote(address token, uint256 voteTokenId, uint256 suspectTokenId) external override returns (bool){
        _suspectVote(token, voteTokenId, suspectTokenId);
        emit OnSuspectVote(msg.sender, token, voteTokenId, suspectTokenId);
        return true;
    }

    function _suspectVote(address token, uint256 voteTokenId, uint256 suspectTokenId) internal {
        require(IERC721(token).ownerOf(voteTokenId) == msg.sender, "Voter must be the owner of the NFT for voting");
        require(!_voted[token][voteTokenId], "Voted already");
        require(_preList[token].contains(suspectTokenId), "target NFT not in the pre list");
        _polls[token][suspectTokenId].increment();
        _voted[token][voteTokenId] = true;
    }

    function suspectVoteRecall(address token, uint256 voteTokenId, uint256 suspectTokenId) external override returns (bool){
        require(IERC721(token).ownerOf(voteTokenId) == msg.sender, "Caller must be the owner of the NFT for recalling");
        require(_voted[token][voteTokenId], "Not voted yet");
        _polls[token][suspectTokenId].increment();
        _voted[token][voteTokenId] = false;

        _polls[token][suspectTokenId].decrement();
        emit OnSuspectVoteRecall(msg.sender, token, voteTokenId, suspectTokenId);
        return true;
    }
}
