## NOTES
systemctl enable podman.socket --now
mkdir -p /opt/fetchit
mkdir -p ~/.fetchit
#update username and password
exit
cp scripts/fetchit/config.yaml ~/.fetchit

cp scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now

podman ps 
