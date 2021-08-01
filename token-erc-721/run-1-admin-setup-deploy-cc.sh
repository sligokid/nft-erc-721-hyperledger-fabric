cd ../test-network
./network.sh down
echo ""

echo "== Start network with CA, create channel =="
sleep 3
./network.sh up createChannel -ca
echo ""

echo "== Deploy ChainCode =="
sleep 3
./network.sh deployCC -ccn token_erc721  -ccp ../token-erc-721/chaincode-javascript/ -ccl javascript
echo ""

echo "== Network Ready =="
echo "----------------------------------------------------------------"
echo ""
sleep 3
