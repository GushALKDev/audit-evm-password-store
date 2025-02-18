### [H-1] Storing the password on-chain makes it visible to anyone, and no longer private

**Description:** All data stored on-chain is visible to anyone and can be read directly from the blockchain. The `PasswordStore::s_password` variable is intended to be a private variable and only accessed through the `PasswordStore::getPassword` function, which is intended to be called only by the owner of the contract.

We show one such method of reading any data off-chain below.

**Impact:** Anyone can read the private password, severely breaking the functionality of the protocol.

**Proof of Concept:**

The following test case shows how anyone can read the password directly from the blockchain.

1. Create a locally running chain:
    ```bash
    make anvil
    ```

2. Deploy the contract to the chain:
    ```bash
    make deploy
    ```

3. Run the storage tool:

    We use `1` because that's the storage slot of `PasswordStore::s_password` in the contract.

    ```bash
    cast storage <CONTRACT_ADDRESS_HERE> 1 --rpc-url 127.0.0.1:8545
    ```

    You will get an output similar to this:

    `0x6d7950617373776f726400000000000000000000000000000000000000000014`

    You can then parse that text to a string with:
    ```bash
    cast parse-bytes32-string 0x6d7950617373776f726400000000000000000000000000000000000000000014
    ```

    And get an output of:

    `myPassword`

**Recommended Mitigation:** Due to this, the overall architecture of the contract should be rethought. One could encrypt the password off-chain and then store the encrypted password on-chain. This would require the user to remember another password off-chain to decrypt the password. However, you would also likely want to remove the view function, as you wouldn't want the user to accidentally send a transaction with the password that decrypts your password.

### [H-2] `PasswordStore::setPassword` has no access controls, meaning a non-owner could set the password

**Description:** The `PasswordStore::setPassword` function is set to be an `external` function. However, the NatSpec of the function and the overall purpose of the smart contract indicate that "This function allows only the owner to set a new password."

```javascript
function setPassword(string memory newPassword) external {
    // @audit - There are no access controls
    s_password = newPassword;
    emit SetNewPassword();
}
```

**Impact:** Anyone can set/change the password of the contract, severely breaking the intended functionality of the contract.

**Proof of Concept:** Add the following to the `PasswordStore.t.sol`:

<details>
<summary>Code</summary>

```javascript
// @audit The function setPassword is not restricted to the owner, allowing anyone to set the password.
function test_anyone_can_set_password(address randomAddress) public {
    vm.startPrank(randomAddress);
    string memory expectedPassword = "myNewPassword";
    passwordStore.setPassword(expectedPassword);

    vm.startPrank(owner);
    string memory actualPassword = passwordStore.getPassword();
    assertEq(actualPassword, expectedPassword);
}
```

</details>

**Recommended Mitigation:** Add an access control conditional to the `PasswordStore::setPassword` function.

```javascript
if (msg.sender != s_owner) {
    revert PasswordStore__NotOwner();
}
```


### [I-1] The NatSpec documentation for `PasswordStore::getPassword` indicates a non-existent parameter, causing the documentation to be incorrect.

**Description:**

```javascript
/*
 * @notice This allows only the owner to retrieve the password.
 * @param newPassword The new password to set.
 */
function getPassword() external view returns (string memory) {
```

The function signature is `PasswordStore::getPassword()`, while the NatSpec documentation indicates it should be `PasswordStore::getPassword(string)`.

**Impact:**
The NatSpec documentation is incorrect.

**Recommended Mitigation:**
Remove the incorrect NatSpec documentation line.

```diff
- * @param newPassword The new password to set.
```
