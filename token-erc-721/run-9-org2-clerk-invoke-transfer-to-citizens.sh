cd ../test-network

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/clerk@org2.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:9051
export TARGET_TLS_OPTIONS="-o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

echo "== Clerk Issues Titles / Transfer NFTs to the Citizens =="
export CLERK="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=clerk::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"
export CITIZEN1="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=citizen1::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"
export CITIZEN2="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=citizen2::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"
export CITIZEN3="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=citizen3::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"

peer chaincode invoke $TARGET_TLS_OPTIONS -C mychannel -n token_erc721 -c '{"function":"TransferFrom","Args":["'"$CLERK"'", "'"$CITIZEN1"'","001/001/001"]}'
peer chaincode invoke $TARGET_TLS_OPTIONS -C mychannel -n token_erc721 -c '{"function":"TransferFrom","Args":["'"$CLERK"'", "'"$CITIZEN2"'","001/001/002"]}'
peer chaincode invoke $TARGET_TLS_OPTIONS -C mychannel -n token_erc721 -c '{"function":"TransferFrom","Args":["'"$CLERK"'", "'"$CITIZEN3"'","001/001/003"]}'
echo ""
sleep 3

echo "== After Transfer NFTs Org2 Clerk Balance =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}'
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'
echo ""

echo "== After Transfer NFTs Org2 OwnerOf =="
for n in $(seq 1 5)
do
  echo "001/001/00${n} -> " `peer chaincode query -C mychannel -n token_erc721 -c '{"function":"OwnerOf","Args":["'"001/001/00${n}"'"]}'`
done
echo ""

echo "== Total Supply is now  =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"TotalSupply","Args":[]}'

echo "----------------------------------------------------------------"
echo ""
sleep 3