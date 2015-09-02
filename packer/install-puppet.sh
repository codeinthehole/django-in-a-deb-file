#!/usr/bin/env bash 

set -x  # Print commands
set -e  # Fail on error

# Install puppet (see https://docs.puppetlabs.com/guides/install_puppet/install_debian_ubuntu.html)
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get install -y puppet
