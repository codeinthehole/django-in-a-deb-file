#!/usr/bin/env bash
# 
# Bump the versions of the package in advance of a git tag and deploy.

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
