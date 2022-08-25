#!/bin/bash 
podman stop gitea && podman rm gitea
sudo rm -rf  /home/svc-gitea/gitea/*