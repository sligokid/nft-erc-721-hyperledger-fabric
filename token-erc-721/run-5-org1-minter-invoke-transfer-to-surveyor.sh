cd ../test-network

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/minter@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051
export TARGET_TLS_OPTIONS="-o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

echo "== Before Transfer NFTs =="
echo "== Org1 Minter Balance =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}'
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'
echo ""
sleep 3

echo "== Transfer all NFTs to the Surveyor =="
export MINTER="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=minter::/C=US/ST=North Carolina/L=Durham/O=org1.example.com/CN=ca.org1.example.com"
export SURVEYOR="x509::/C=US/ST=North Carolina/O=Hyperledger/OU=client/CN=surveyor::/C=UK/ST=Hampshire/L=Hursley/O=org2.example.com/CN=ca.org2.example.com"

for n in $(seq 1 5)
do
  peer chaincode invoke $TARGET_TLS_OPTIONS -C mychannel -n token_erc721 -c '{"function":"TransferFrom","Args":["'"$MINTER"'", "'"$SURVEYOR"'","'"001/001/00${n}"'"]}'
done

echo ""
sleep 3

echo "== After Transfer NFTs Org1 Minter Balance =="
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}'
peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'

echo "----------------------------------------------------------------"
echo ""
sleep 3