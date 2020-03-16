#!/bin/sh 
set -e

yum update --setopt=tsflags=nodocs -y sqlite \
nss-softokn \
nss \
nss-sysinit \
nss-tools \
nss-util \
nss-softokn-freebl