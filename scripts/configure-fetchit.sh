## NOTES
systemctl enable podman.socket --now
mkdir -p /opt/fetchit
cp fetchit/fetchit-root.servicee /etc/systemd/system/fetchit.service
systemctl enable fetchit --now