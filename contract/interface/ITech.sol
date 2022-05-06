//SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.6.0;

interface ITech {
    event OnSuspectVote(address indexed voter, address indexed token, uint256 indexed voteTokenId, uint256 suspectTokenId);
    event OnSuspectVoteBatch(address indexed voter, address indexed token, uint256[] indexed voteTokenIds, uint256 suspectTokenId);
    event OnSuspectVoteRecall(address indexed recaller, address indexed token, uint256 indexed voteTokenId, uint256 suspectTokenId);
    event OnAddNftToPreList(address indexed caller, address indexed token, uint256 indexed suspectTokenId);

    /**
     * @dev Get the poll of a suspect NFT.
     * @param `token` NFT contract address.
     * @param `suspectTokenId` ID of the suspect NFT.
     * @return Returns the poll of a suspect NFT.
     */
    function suspectPoll(address token, uint256 suspectTokenId) external view returns (uint256 poll);
    /**
     * @dev Get all of NFTs of a specific NFT contract in the pre list.
     * @param `token` NFT contract address.
     * @return Returns all of NFTs of a specific NFT contract in the pre list.
     */
    function preList(address token) external view returns (uint256[] memory);
    /**
    * @dev Get all of the contract addresses in the pre list.
    * @return Returns all of the contract addresses in the pre list.
     */
    function contrList() external view returns (address[] memory);
    /**
     * @dev Adds a suspect NFT to the pre list for being voted and emits a {OnAddNftToPreList} event.
     * @param `token` NFT contract address.
     * @param `suspectTokenId` ID of the suspect NFT.
     * @return Returns a boolean value indicating whether the operation succeeded.
     */
    function addNftToPreList(address token, uint256 suspectTokenId) external returns (bool);
    /**
     * @dev Votes to the suspect NFT and emits a {OnSuspectVote} event.
     * @param `token` NFT contract address.
     * @param `voteTokenId` ID of the NFT which will be used to vote.
     * @param `suspectTokenId` ID of the suspect NFT.
     * @return Returns a boolean value indicating whether the operation succeeded.
     */
    function suspectVote(address token, uint256 voteTokenId, uint256 suspectTokenId) external returns (bool);
    /**
     * @dev Votes to the suspect NFT and emits a {OnSuspectVoteBatch} event.
     * @param `token` NFT contract address.
     * @param `voteTokenIds` IDs of the NFTs which will be used to vote.
     * @param `suspectTokenId` ID of the suspect NFT.
     * @return Returns a boolean value indicating whether the operation succeeded.
     */
    function suspectVoteBatch(address token, uint256[] calldata voteTokenIds, uint256 suspectTokenId) external returns (bool);
    /**
     * @dev Recalls a vote to the suspect NFT and emits a {OnSuspectVoteRecall} event.
     * @param `token` NFT contract address.
     * @param `voteTokenId` ID of the NFT which was used to vote.
     * @param `suspectTokenId` ID of the suspect NFT.
     * @return Returns a boolean value indicating whether the operation succeeded.
     */
    function suspectVoteRecall(address token, uint256 voteTokenId, uint256 suspectTokenId) external returns (bool);
}