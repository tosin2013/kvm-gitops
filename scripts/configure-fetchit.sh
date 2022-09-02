#!/bin/bash


systemctl enable podman.socket --now
mkdir -p /opt/fetchit
mkdir -p ~/.fetchit

cp scripts/fetchit/example-config.yaml ~/.fetchit/config.yaml

cp scripts/fetchit/fetchit-root.service /etc/systemd/system/fetchit.service
systemctl enable fetchit --now

podman ps 
