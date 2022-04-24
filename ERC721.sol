//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.20;

interface ERC721 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);
}

interface ERC721Metadata {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);
    // function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

contract myNFT is ERC721, ERC721Metadata, ERC165 {
    //Metadata
    string private _tokenName;
    string private _tokenSymbol;
    uint8 private id = 1;

    constructor(string memory _name, string memory _symbol) {
        _tokenName = _name;
        _tokenSymbol = _symbol;
    }

    function name() external view virtual override returns (string memory) {
        return _tokenName;
    }

    function symbol() external view virtual override returns (string memory) {
        return _tokenSymbol;
    }

    function baseUri() internal pure returns (string memory) {
        return "www.ipfs.com/q/";
    }

    //EIP-721 Standard

    mapping(address => uint256) private _balance;
    mapping(uint256 => address) private _owners;
    mapping(uint256 => string) private _tokenURIs;

    function balanceOf(address _owner)
        external
        view
        virtual
        override
        returns (uint256)
    {
        require(_owner != address(0), "Invalid Query");
        return _balance[_owner];
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[_tokenId];
        require(owner != address(0), "Invalid NFT/Token");
        return owner;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable virtual override {
        require(msg.sender != _to, "Invalid Reciever Address");
        require(_to != address(0), "Invalid Reciever Address");
        require(_from == msg.sender, "Not the current owner");
        address owner = _owners[_tokenId];
        require(owner != address(0), "Invalid NFT/Token");
        _transfer(_from, _to, _tokenId);
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal virtual {
        _balance[_from] -= 1;
        _balance[_to] += 1;
        _owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal virtual {
        require(_exists(tokenId), "Token does not exist");
        _tokenURIs[tokenId] = uri;
    }

    function mint(address to, string memory uri) public payable {
        uint256 tokenId = id;
        _owners[tokenId] = to;
        _balance[to] += 1;
        id++;
        _setTokenURI(tokenId, uri);
        emit Transfer(address(0), to, tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable virtual override {
        require(msg.sender != _to, "Invalid Reciever Address");
        require(_to != address(0), "Invalid Reciever Address");
        require(_from == msg.sender, "Not the current owner");
        address owner = _owners[_tokenId];
        require(owner != address(0), "Invalid NFT/Token");
        _transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable virtual override {}

    function approve(address _approved, uint256 _tokenId)
        external
        payable
        virtual
        override
    {}

    function setApprovalForAll(address _operator, bool _approved)
        external
        virtual
        override
    {}

    function getApproved(uint256 _tokenId)
        external
        view
        virtual
        override
        returns (address)
    {}

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        virtual
        override
        returns (bool)
    {}

    //EIP-165

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165)
        returns (bool)
    {
        return
            interfaceId == type(ERC721).interfaceId ||
            interfaceId == type(ERC721Metadata).interfaceId ||
            interfaceId == type(ERC165).interfaceId;
    }
}
