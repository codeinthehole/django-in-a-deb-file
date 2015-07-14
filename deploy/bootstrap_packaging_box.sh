#!/usr/bin/env bash
#
# Set-up the Vagrant box for BUILDING debian packages

apt-get update
apt-get install dh-virtualenv devscripts debhelper python-dev python-pip -y
pip install -U pip
