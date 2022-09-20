#!/bin/bash


systemctl stop fetchit.service
systemctl disable fetchit.service
rm  -rf /etc/systemd/system/fetchit.service
#rm /etc/systemd/system/fetchit.service # and symlinks that might be related
systemctl daemon-reload
systemctl reset-failed
