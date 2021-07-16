import "../helpers/Ownable.sol";


// SPDX-License-Identifier: WTFPL

pragma solidity 0.8.2;

abstract contract Whitelistable is Ownable {

    mapping(address => bool) public whitelisted;
    mapping (address => mapping (address => bool)) public underlyingTokenInTheLp;
    mapping (address => uint256) public numberOfUnderlyingTokens;

    event Added(address token);
    event Removed(address token);

    /**
    * @dev Require adapter registered
    */
    modifier onlyWhitelisted(address _strategy) {
        require(whitelisted[_strategy], "Whitelistable#onlyWhitelisted: not whitelisted lp");
        _;
    }

    /**
    * @dev add pool token to whitelist
    * @param _token pool address
    */
    function add(address _token) 
        public 
        onlyOwner 
    {
        _add(_token);
        addToUnderlyingTokenMapping(_token);
    }

    /**
    * @dev batch add pool token to whitelist
    * @param _tokens[] array of pool address
    */
    function addBatch(address[] memory _tokens)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _tokens.length; i++) {
            _add(_tokens[i]);
            addToUnderlyingTokenMapping(_tokens[i]);
        }
    }

    /**
    * @dev remove pool token from whitelist
    * @param _token pool address
    */
    function remove(address _token) 
        public
        onlyOwner
    {
        _remove(_token);
        removeFromUnderlyingTokenMapping(_token);
    }

    /**
    * @dev batch remove pool token from whitelist
    * @param _tokens[] array of pool address
    */
    function removeBatch(address[] memory _tokens)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _tokens.length; i++) {
            _remove(_tokens[i]);
            removeFromUnderlyingTokenMapping(_tokens[i]);
        }
    }

    function _add(address _token) 
        internal
    {
        whitelisted[_token] = true;
        emit Added(_token);
    }

    function _remove(address _token) 
        internal
    {
        require(whitelisted[_token], 'Whitelistable#_Remove: not exist');
        whitelisted[_token] = false;
        emit Removed(_token);
    }

    function addToUnderlyingTokenMapping(address _token) internal virtual;
    function removeFromUnderlyingTokenMapping(address _token) internal virtual;
}
