cd ../test-network

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/recipient@org2.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:9051

for n in surveyor planner clerk citizen1 citizen2 citizen3
do
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/${n}@org2.example.com/msp
   echo "== Org2 ${n} Identity and Balance =="
  peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountID","Args":[]}'
  peer chaincode query -C mychannel -n token_erc721 -c '{"function":"ClientAccountBalance","Args":[]}'
done

