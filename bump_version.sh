#!/usr/bin/env bash
# 
# Bump the versions of the package in advance of a git tag and deploy.

# Determine new version number
PYTHON_VERSION=$1

# See https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version for more on 
# Debian versioning conventions.
DEBIAN_VERSION="$PYTHON_VERSION-1"

# Update version for python project
VERSION_FILE=src/helloworld/version.py
echo "Updating $VERSION_FILE"
echo "__version__ = '$PYTHON_VERSION'" > $VERSION_FILE

# Update debian changelog using `dch` command
COMMIT=$(git rev-parse HEAD)
DESCRIPTION="Built from commit $COMMIT"
echo "Updating debian/changelog"
vagrant ssh packaging -- "cd /vagrant/ && dch --newversion=$DEBIAN_VERSION --controlmaint --urgency=medium --distribution=unstable $DESCRIPTION"
