#!/bin/bash 
sudo podman stop gitea && sudo podman rm gitea
sudo rm -rf  /home/svc-gitea/gitea/