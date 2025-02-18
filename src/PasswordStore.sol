// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; // q is this the correct compiler version?

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {
    // n maybe use better error message as "NotOwner()"
    error PasswordStore__NotOwner();

    /*//////////////////////////////////////////////////////////////
                             STATE VARIABLE
    //////////////////////////////////////////////////////////////*/

    address private s_owner;
    // @audit The s_passord is not actually private! This is not a safe place to store passwords.
    string private s_password;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows the owner to set a new password.
     * @param newPassword The new password to set.
     */
    // n (if there is no documentation for the function, it is better to add a comment to explain the function)
    // q ie, what this function does, what is the purpose of this function?
    // q can a non-owner set the password?
    // @audit The function setPassword is not restricted to the owner, allowing anyone to set the password.
    // missing access control
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     */
     // @audit Documentation issue. No param needed on getPassword function.
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}