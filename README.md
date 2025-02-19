
# PasswordStore Audit

## PasswordStore Dapp

<br/>
<p align="center">
<img src="./password-store-logo.png" width="400" alt="password-store">
</p>
<br/>

A smart contract application for storing a password. Users should be able to store a password and then retrieve it later. Others should not be able to access the password. 

[Testnet deployment](https://sepolia.etherscan.io/address/0x2ecf6ad327776bf966893c96efb24c9747f6694b)

- [PasswordStore Audit](#passwordstore-audit)
  - [PasswordStore Dapp](#passwordstore-dapp)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Deploy (local)](#deploy-local)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
  - [Audit Scope Details](#audit-scope-details)
  - [Compatibilities](#compatibilities)
  - [Roles](#roles)
  - [Create the audit report](#create-the-audit-report)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

## Quickstart

```
git clone https://github.com/Cyfrin/3-passwordstore-audit
cd 3-passwordstore-audit
forge build
```

# Usage

## Deploy (local)

1. Start a local node

```
make anvil
```

2. Deploy

This will default to your local node. You need to have it running in another terminal in order for it to deploy.

```
make deploy
```

## Testing

```
forge test
```

### Test Coverage

```
forge coverage
```

and for coverage based testing: 

```
forge coverage --report debug
```

## Audit Scope Details

- Commit Hash:  7d55682ddc4301a7b13ae9413095feffd9924566
- In Scope:
```
./src/
└── PasswordStore.sol
```

## Compatibilities

- Solc Version: 0.8.18
- Chain(s) to deploy contract to: Ethereum
- Tokens: None

## Roles

- Owner: The user who can set the password and read the password.
- Outsiders: No one else should be able to set or read the password.

## Create the audit report

View the [audit-report-templating](https://github.com/Cyfrin/audit-report-templating) repo to install all dependencies. 

```bash
cd audits
pandoc 2023-09-01-password-store-report.md -o report.pdf --from markdown --template=eisvogel --listings
```