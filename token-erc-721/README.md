# Land Registry First Registration - NFT (Hyperledger Fabric)

### Smart Registration  

This POC mimics a real world use case of first registration of land. Since a land parcel is a physical asset
it can be represented by an NFT.

Today during first registration of land a land parcel is identified by a unique parcel identifier UPI. Before a land title
can be issued to a citizen it must pass through several approval processes by several entities. These entities are registered
as participants on this platform and the parcel ownerships is transferred to each entity once approved.

An example of the flow of a parcel during registration is:
- enumerator -> surveyor -> planner -> clerk -> citizen

Approvals are recorded on the blockchain as the assets change ownership, Rejections are recorded as the token is burned.

In the final step each NFT still active is transferred to a citizen.

---
#### Architecture   
This POC creates a permissioned blockchain network consisting of 
- 1 orderer
- 2 organisation peers
- 2 organisation CA

Each CA manages participants within each organisation 

- CA-Org1 
    - administrator
    - minter

- CA-Org2 
    - surveyor
    - planner
    - clerk
    - citizen1
    - citizen2
    - citizen3
---
### Setup
> Install project dependencies see docs/README.md

---
### NFT (Land Parcels) mint -> approve -> transfer -> issue title  

### Demo
> End to end demo
```bash
sh run-demo-end-to-end.sh 
```
OR

>Shell 1 - (Admin) Launch blockhain platform 
```bash
sh run-1-admin-setup-deploy-cc.sh
`````

>Shell 1 - (Admin) Register and enrol the mint 
```bash
sh run-2-org1-admin-enroll-minter-in-ca.sh
`````

>Shell 1 - (Admin) Register and enrol the participants 
```bash
sh run-3-org2-admin-enroll-participants.sh
`````

>Shell 2 - (Mint) Create 5 NFTs representing 5 parcels 
```bash
sh run-4-org1-minter-invoke-mint-nfts.sh
`````

>Shell 2 - (Mint) Transfer 5 NFTs to Surveyor 
```bash
sh run-5-org1-minter-invoke-transfer-to-surveyor.sh
`````

>Shell 3 - (Surveyor) List current NFT owners 
```bash
sh run-6-org2-surveyor-query-owner-of.sh  
`````

>Shell 3 - (Surveyor) Transfer 4 NFTs to Planner, Reject 1 (Burn it) 
```bash
sh run-7-org2-surveyor-invoke-transfer-to-planner.sh 
`````

>Shell 4 - (Planner) Transfer 3 NFTs to Clerk, Reject 1 (Burn it) 
```bash
sh run-8-org2-planner-invoke-transfer-to-clerk.sh 
`````

>Shell 4 - (Clerk) Transfer 3 NFTs to 3 Citizens (1 each) i.e. issue proof of title 
```bash
sh run-9-org2-clerk-invoke-transfer-to-citizens.sh`````


---
##### Credits
🙏 This project is a fork of hyperledger fabric SDK

> base version : 
```bash
curl -sSL https://bit.ly/2ysbOFE | bash -s
```