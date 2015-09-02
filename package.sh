#/usr/bin/env bash
#
# Create a new Debian package
#
# Bump the versions of the package in advance of a git tag a
# deploy.

set -e

PACKAGE=helloworld

# Use date and commit SHA as version number
COMMIT_SHA=$(git rev-parse HEAD)
VERSION="$(date +"%Y%m%d")-${COMMIT_SHA:0:8}"

# Update version for python project
VERSION_FILE=src/$PACKAGE/version.py
echo "Updating $VERSION_FILE"
echo "__version__ = '$VERSION'" > $VERSION_FILE

# Update debian changelog using `dch` command
COMMIT_SHA=$(git rev-parse HEAD)
DESCRIPTION="Built from commit $COMMIT_SHA"

echo "Updating debian/changelog"
BUILD_DATE=$(date +"%a, %d %b %Y %H:%M:%S %z")
cat debian/changelog.template | \
    sed "s/PACKAGE/$PACKAGE/" | \
    sed "s/VERSION/$VERSION/" | \
    sed "s/DESCRIPTION/$DESCRIPTION/" | \
    sed "s/BUILD_DATE/$BUILD_DATE/" > debian/changelog

echo "Pre-packaging steps"
src/manage.py collectstatic --noinput

echo "Creating package"
vagrant ssh packaging -- "cd /vagrant/ && sudo dpkg-buildpackage -us -uc"
vagrant ssh packaging -- "sudo mv /*.deb /vagrant"

#echo "Testing package"
#vagrant ssh test -- "cd /vagrant/ && sudo gdebi *.deb"
