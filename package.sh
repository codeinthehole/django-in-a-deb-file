#/usr/bin/env bash

set -e

echo "Pre-packaging steps"
helloworld/manage.py collectstatic --noinput

echo "Creating package"
vagrant ssh packaging -- "cd /vagrant/ && sudo dpkg-buildpackage -us -uc"
vagrant ssh packaging -- "sudo mv /*.deb /vagrant"

echo "Testing package"
vagrant ssh test -- "cd /vagrant/ && sudo gdebi *.deb"
