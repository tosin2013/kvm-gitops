#!/bin/bash 
if [ -f $HOME/gitops-catalog ]; then
  echo "gitops-catalog found"
else
  echo "gitops-catalog not found"
  exit 1
fi

cd $HOME/gitops-catalog
