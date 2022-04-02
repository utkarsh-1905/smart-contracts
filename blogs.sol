//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0;
pragma abicoder v2;

contract blog {
    struct Blogs {
        string content;
        string image;
    }

    mapping(address => Blogs[]) blogs;

    // function transferBlog(address _newOwner,address payable _currOwner, uint _blogNumber,uint amount) payable public{

    // }

    function getBlog(address _author, uint256 _blogNumber)
        public
        view
        returns (Blogs memory)
    {
        return blogs[_author][_blogNumber];
    }

    function getAllBlogsByAuthor(address _author)
        public
        view
        returns (Blogs[] memory)
    {
        return blogs[_author];
    }

    function writeBlogs(string memory _content, string memory _imageURL)
        public
    {
        blogs[msg.sender].push(Blogs(_content, _imageURL));
    }
}
