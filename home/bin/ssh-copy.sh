#!/usr/bin/env bash
set -ex
host=$1
user=$2
user=${user:=$USER}

ssh ${user}@${host} 'test -d ~/.ssh || mkdir -m 700 ~/.ssh'
ssh ${user}@${host} 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
ssh ${user}@${host} 'chmod 600 ~/.ssh/authorized_keys'
