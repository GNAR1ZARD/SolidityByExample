// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Interface for querying contract support for specific interfaces.
 */
interface IERC165 {
    /**
     * @dev Checks whether the contract supports a given interface.
     * @param interfaceID The interface identifier.
     * @return True if the contract supports the interface, false otherwise.
     */
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

/**
 * @title Interface for ERC-721 tokens, including balance queries, owner lookups, transfers, and approvals.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Gets the balance of tokens owned by a specific address.
     * @param owner The address to query the balance for.
     * @return balance The balance of tokens owned by the address.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Gets the balance of tokens owned by a specific address.
     * @param owner The address to query the balance for.
     * @return owner The balance of tokens owned by the address.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers a token from one address to another.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param tokenId The ID of the token to be transferred.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Safely transfers a token from one address to another with additional data.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param tokenId The ID of the token to be transferred.
     * @param data Additional data that may accompany the transfer.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Transfers a token from one address to another.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param tokenId The ID of the token to be transferred.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Approves an address to spend a specific token.
     * @param to The address to be approved.
     * @param tokenId The ID of the token to be approved.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Gets the approved address for a specific token.
     * @param tokenId The ID of the token to query approval for.
     * @return operator The address approved to spend the token.
     */
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Sets or revokes approval for an operator to manage all of the sender's tokens.
     * @param operator The operator's address.
     * @param _approved True to approve, false to revoke.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Checks whether an operator is approved to manage all tokens of a specific owner.
     * @param owner The owner's address.
     * @param operator The operator's address.
     * @return True if approved, false otherwise.
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

/**
 * @title Interface for contracts that can receive ERC-721 tokens.
 */
interface IERC721Receiver {
    /**
     * @dev Handles the receipt of an ERC-721 token.
     * @param operator The address which called `safeTransferFrom` function.
     * @param from The owner's address, token is transferred from.
     * @param tokenId The ID of the token received.
     * @param data Additional data that may accompany the transfer.
     * @return A bytes4 magic value indicating success or failure.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @title Main ERC-721 contract implementation.
 */
contract ERC721 is IERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed id
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 indexed id
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // Mapping from token ID to owner address
    mapping(uint256 => address) internal _ownerOf;

    // Mapping owner address to token count
    mapping(address => uint256) internal _balanceOf;

    // Mapping from token ID to approved address
    mapping(uint256 => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /**
     * @dev Function to check if the contract supports specific interfaces.
     * @param interfaceId The interface identifier.
     * @return True if the contract supports the interface, false otherwise.
     */
    function supportsInterface(bytes4 interfaceId)
        external
        pure
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @dev Function to get the owner of a specific token.
     * @param id The token ID to query ownership for.
     * @return owner The address of the owner of the token.
     */
    function ownerOf(uint256 id) external view returns (address owner) {
        owner = _ownerOf[id];
        require(owner != address(0), "token doesn't exist");
    }

    /**
     * @dev Function to get the balance of tokens owned by an address.
     * @param owner The address to query the balance for.
     * @return The balance of tokens owned by the address.
     */
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    /**
     * @dev Function to set approval for all tokens to be transferred by a specific operator.
     * @param operator The operator's address.
     * @param approved True to approve, false to revoke.
     */
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev Function to approve an address to transfer a specific token.
     * @param spender The address to be approved.
     * @param id The ID of the token to be approved.
     */
    function approve(address spender, uint256 id) external {
        address owner = _ownerOf[id];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authorized"
        );

        _approvals[id] = spender;

        emit Approval(owner, spender, id);
    }

    /**
     * @dev Function to get the approved address for a specific token.
     * @param id The ID of the token to query approval for.
     * @return The address approved to spend the token.
     */
    function getApproved(uint256 id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _approvals[id];
    }

    /**
     * @dev Internal function to check if an address is approved or is the owner of a specific token.
     * @param owner The owner's address.
     * @param spender The spender's address.
     * @param id The ID of the token.
     * @return True if approved or owner, false otherwise.
     */
    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint256 id
    ) internal view returns (bool) {
        return (spender == owner ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[id]);
    }

    /**
     * @dev Function to transfer a token from one address to another.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param id The ID of the token to be transferred.
     */
    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public {
        require(from == _ownerOf[id], "from != owner");
        require(to != address(0), "transfer to zero address");

        require(_isApprovedOrOwner(from, msg.sender, id), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id];

        emit Transfer(from, to, id);
    }

    /**
     * @dev Function to safely transfer a token from one address to another.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param id The ID of the token to be transferred.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    id,
                    ""
                ) ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    /**
     * @dev Function to safely transfer a token from one address to another with additional data.
     * @param from The sender's address.
     * @param to The recipient's address.
     * @param id The ID of the token to be transferred.
     * @param data Additional data that may accompany the transfer.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes calldata data
    ) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    id,
                    data
                ) ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    /**
     * @dev Internal function to mint a new token and assign it to an address.
     * @param to The address to which the token will be minted.
     * @param id The ID of the token to be minted.
     */
    function _mint(address to, uint256 id) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    /**
     * @dev Internal function to burn a token.
     * @param id The ID of the token to be burned.
     */
    function _burn(uint256 id) internal {
        address owner = _ownerOf[id];
        require(owner != address(0), "not minted");

        _balanceOf[owner] -= 1;

        delete _ownerOf[id];
        delete _approvals[id];

        emit Transfer(owner, address(0), id);
    }
}

/**
 * @title Custom ERC-721 contract (MyNFT) that extends the ERC721 base.
 */
contract MyNFT is ERC721 {
    /**
     * @dev Mint a new token and assign it to an address.
     * @param to The address to which the token will be minted.
     * @param id The ID of the token to be minted.
     */
    function mint(address to, uint256 id) external {
        _mint(to, id);
    }

    /**
     * @dev Burn a token owned by the sender.
     * @param id The ID of the token to be burned.
     */
    function burn(uint256 id) external {
        require(msg.sender == _ownerOf[id], "not owner");
        _burn(id);
    }
}
