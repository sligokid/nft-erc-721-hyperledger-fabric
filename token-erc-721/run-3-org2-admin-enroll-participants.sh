cd ../test-network

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

echo "== As CA for Org2 register particpants and provide identities =="
sleep 3
for n in surveyor planner clerk citizen1 citizen2 citizen3
 do
  fabric-ca-client register --caname ca-org2 --id.name ${n}   --id.secret ${n}pw  --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
done
echo ""

echo "== As CA for Org2 enroll the particpants with Org2 MSP =="
sleep 3
for n in surveyor planner clerk citizen1 citizen2 citizen3
do
  fabric-ca-client enroll -u https://${n}:${n}pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/${n}@org2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
done
echo ""

echo "== Provide a copy of the MSP config to the particpants =="
for n in surveyor planner clerk citizen1 citizen2 citizen3
do
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/${n}@org2.example.com/msp/config.yaml
done

echo "----------------------------------------------------------------"
echo ""
sleep 3