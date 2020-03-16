#!/bin/sh
set -e

yum update --setopt=tsflags=nodocs -y  kernel-headers \
nss-softokn \
nss \
nss-sysinit \
nss-tools \
nss-util \
nss-softokn-freebl