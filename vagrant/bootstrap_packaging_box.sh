#!/usr/bin/env bash
#
# Set-up the Vagrant box for BUILDING debian packages

apt-get update
apt-get install dh-virtualenv devscripts debhelper python-dev python-pip -y
pip install -U pip devpi-server

# Use upstart to manage devpi process
cp /vagrant/vagrant/devpi.conf /etc/init/
start devpi
