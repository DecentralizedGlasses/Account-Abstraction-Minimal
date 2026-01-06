# About

1. Create a basic AA in ethereum
2. Create a basic AA on zksync
3. Deploy, and send a userOp/ transaction through them
   1. not going to send an AA in ethreum
   2. But we will send an AA tx to zksync


---

# Account Abstraction – Minimal Implementation (Ethereum & zkSync)

This repository contains a **minimal, from-scratch implementation of Account Abstraction (AA)** built on:

* **Ethereum (EIP-4337 based Account Abstraction)**
* **zkSync (Native Account Abstraction)**

The purpose of this project is **learning and clarity** — to understand how Account Abstraction works internally without unnecessary abstractions, UI layers, or production-level complexity.

---

## What is Account Abstraction?

In traditional Ethereum:

* User accounts are **Externally Owned Accounts (EOAs)**
* EOAs:

  * Must hold ETH for gas
  * Use a single private key
  * Follow fixed transaction rules

**Account Abstraction (AA)** allows **smart contracts to act as user accounts**, enabling:

* Custom signature logic
* Gas payment using tokens (not only ETH)
* Social recovery & multisig wallets
* Transaction batching
* Programmable validation and execution rules

---

## What is Minimal Account Abstraction?

**Minimal Account Abstraction** means:

* Implementing only the **core required components**
* Avoiding unnecessary abstractions
* Focusing on:

  * Validation
  * Execution
  * Gas handling
  * EntryPoint or protocol-level flow

This repository intentionally keeps everything minimal so the **entire AA flow is understandable**.

---

## What I Implemented in This Project

### Ethereum – EIP-4337 Based Account Abstraction

Ethereum does **not** support Account Abstraction natively.
It uses **EIP-4337**, which introduces an **EntryPoint contract** and `UserOperation` flow.

Implemented features:

* A minimal smart-contract wallet implementing `IAccount`
* Custom `validateUserOp` logic
* Signature verification
* Interaction with `EntryPoint`
* Full execution flow testing using **Foundry**

High-level flow:

```
UserOperation
   ↓
EntryPoint
   ↓
validateUserOp()
   ↓
execute()
```

---

### zkSync – Native Account Abstraction

zkSync supports **Account Abstraction at the protocol level**, meaning:

* No EntryPoint contract
* No bundlers
* Validation and execution are handled natively

Implemented features:

* Minimal zkSync account contract
* Native validation & execution logic
* zkSync-specific tests

High-level flow:

```
Transaction
   ↓
Validation Phase
   ↓
Execution Phase
```

---

## Ethereum vs zkSync – Advantages & Disadvantages

### Ethereum (EIP-4337)

**Advantages**

* Works on Ethereum mainnet
* Standardized via EIP-4337
* Backward compatible
* Mature ecosystem

**Disadvantages**

* Complex architecture
* Requires EntryPoint and bundlers
* Higher gas costs
* More boilerplate code

---

### zkSync (Native AA)

**Advantages**

* Native Account Abstraction
* No EntryPoint or bundlers
* Lower gas fees
* Cleaner developer experience
* Simpler execution flow

**Disadvantages**

* zkSync-specific implementation
* Different tooling
* Smaller ecosystem compared to Ethereum
* Learning curve for zk-based systems

---

## Tech Stack

* Solidity
* Foundry
* Ethereum EIP-4337
* zkSync Native Account Abstraction
* OpenZeppelin Contracts

---

## Project Structure

```
├── src/
│   ├── ethereum/
│   │   └── MinimumAccount.sol
│   ├── zksync/
│   │   └── ZkMinimalAccount.sol
│
├── test/
│   ├── ethereum/
│   ├── zksync/
│
├── lib/
│   └── account-abstraction
│
├── foundry.toml
└── README.md
```

---

## Prerequisites

Make sure the following are installed:

* Git
* Foundry
* Node.js (optional, for zkSync tooling)

Install Foundry:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

---

## Clone the Repository

```bash
git clone https://github.com/DecentralizedGlasses/Account-Abstraction-Minimal.git
cd Account-Abstraction-Minimal
```

---

## Install Dependencies

```bash
forge install
```

---

## Run Ethereum (EIP-4337) Tests

```bash
forge test
```

Verbose output:

```bash
forge test -vvvv
```

---

## Run zkSync Tests

```bash
forge test --zksync
```

> zkSync uses native Account Abstraction phases, so behavior differs from Ethereum tests.

---

## Learning Outcomes

By working through this project, you will understand:

* How `validateUserOp` works internally
* Why EntryPoint exists in Ethereum AA
* Differences between contract-based and native AA
* zkSync validation and execution phases
* Real Account Abstraction execution flow

---

## References

* EIP-4337 – Account Abstraction
* zkSync Native Account Abstraction Documentation
* OpenZeppelin Contracts
* Cyfrin Account Abstraction Resources

---

## Contributing

This is an educational project.
Feel free to fork and extend it with:

* Paymasters
* Gas sponsorship
* Multisig wallets
* Social recovery mechanisms

---

## Final Note

This repository is intentionally **minimal**.

If you understand everything in this codebase,
you **truly understand Account Abstraction**.

---
