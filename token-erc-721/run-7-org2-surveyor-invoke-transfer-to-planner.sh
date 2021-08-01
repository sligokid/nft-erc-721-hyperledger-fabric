cd ../test-network

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/surveyor@org2.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:9051
export TARGET_TLS_OPTIONS="-o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

echo "== Before Transfer NFTs =="
echo "== Org2 Surveyor Balance =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}'
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'
echo ""
sleep 3

echo "== Surveyor Transfer just first 4 NFTs to the Planner =="
export MINTER="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=minter::/C=US/ST=North Carolina/L=Durham/O=org1.example.com/CN=ca.org1.example.com"
export SURVEYOR="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=surveyor::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"
export PLANNER="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=planner::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"

for n in $(seq 1 4)
do
  peer chaincode invoke $TARGET_TLS_OPTIONS -C mychannel -n token_erc721 -c '{"function":"TransferFrom","Args":["'"$SURVEYOR"'", "'"$PLANNER"'","'"001/001/00${n}"'"]}'
done

echo ""
sleep 3

echo "== Surveyor Rejects 1 NFT, burning token =="
for n in 5
do
  peer chaincode invoke $TARGET_TLS_OPTIONS -C mychannel -n token_erc721 -c '{"function":"Burn","Args":["'"001/001/00${n}"'"]}'
done
echo ""
sleep 3

echo "== After Transfer NFTs Org2 Surveyor Balance =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}'
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'

echo "== After Transfer NFTs Org2 OwnerOf =="
for n in $(seq 1 5)
do
  echo "001/001/00${n} -> " `peer chaincode query -C mychannel -n token_erc721 -c '{"function":"OwnerOf","Args":["'"001/001/00${n}"'"]}'`
done

echo "== Total Supply is now  =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"TotalSupply","Args":[]}'

echo "----------------------------------------------------------------"
echo ""
sleep 3