#/usr/bin/env bash

echo "Creating package"
vagrant ssh packaging -- "cd /vagrant/ && sudo dpkg-buildpackage -us -uc"
vagrant ssh packaging -- "sudo mv /*.deb /vagrant"

echo "Testing package"
vagrant ssh test -- "cd /vagrant/ && sudo gdebi *.deb"

echo "Cleaning up"
-rm -rf build dist *.deb
