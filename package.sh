#/usr/bin/env bash
#
# Create a new Debian package
#
# Bump the versions of the package in advance of a git tag a
# deploy.

set -e

# Determine new version number
PYTHON_VERSION=$1
DEBIAN_VERSION=${2:-1}

# See https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version for more on 
# Debian versioning conventions.
DEBIAN_VERSION="$PYTHON_VERSION-$DEBIAN_VERSION"

# Update version for python project
VERSION_FILE=src/helloworld/version.py
echo "Updating $VERSION_FILE"
echo "__version__ = '$PYTHON_VERSION'" > $VERSION_FILE

# Update debian changelog using `dch` command
COMMIT=$(git rev-parse HEAD)
DESCRIPTION="Built from commit $COMMIT"

echo "Updating debian/changelog"
BUILD_DATE=$(date +"%a, %d %b %Y %H:%M:%S %z")
cat debian/changelog.template | \
    sed "s/PACKAGE/helloworld/" | \
    sed "s/VERSION/$DEBIAN_VERSION/" | \
    sed "s/DESCRIPTION/$DESCRIPTION/" | \
    sed "s/BUILD_DATE/$BUILD_DATE/" > debian/changelog

echo "Pre-packaging steps"
src/manage.py collectstatic --noinput

echo "Creating package"
vagrant ssh packaging -- "cd /vagrant/ && sudo dpkg-buildpackage -us -uc"
vagrant ssh packaging -- "sudo mv /*.deb /vagrant"

echo "Testing package"
vagrant ssh test -- "cd /vagrant/ && sudo gdebi *.deb"
