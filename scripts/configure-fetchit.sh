## NOTES


systemctl enable podman.socket --now
mkdir -p /opt/fetchit
mkdir -p ~/.fetchit
#update username and password
exit

QUBINODE_DEPLOYMENT=true
if [ $QUBINODE_DEPLOYMENT == true ]; then
    echo "QUBINODE_DEPLOYMENT is true"
    IPADDRESS=$(hostname -I | awk '{print $1}')
    sed -i "s/CHANGEME/${IPADDRESS}/g" scripts/fetchit/qubinode-vars-config.yaml
    cp scripts/fetchit/qubinode-vars-config.yaml ~/.fetchit/config.yaml
else
    echo "QUBINODE_DEPLOYMENT is false"
    cp scripts/fetchit/example-config.yaml ~/.fetchit/config.yaml
fi


cp scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now

podman ps 
