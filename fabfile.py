import os
import glob
import shutil
import datetime

import pytz
from fabric import api

PACKAGE = "helloworld"

TEMP_FOLDERS = (
    "build",
    "dist",
    "debian/usr/share/static",
    "debian/%s" % PACKAGE,
    "src/%s.egg-info" % PACKAGE,
)

TEMP_FILES = (
    "debian/%s.debhelper.log" % PACKAGE,
    "debian/changelog",
    "debian/files",
    "src/%s/version.py" % PACKAGE,
    "src/db.sqlite3",
)

DEBIAN_CHANGELOG_TEMPLATE = """PACKAGE (VERSION) unstable; urgency=medium

  * DESCRIPTION

 -- AUTHOR <AUTHOR_EMAIL>  BUILD_DATE
"""


def clean():
    """
    Remove temporary files
    """
    for folder in TEMP_FOLDERS:
        if os.path.exists(folder):
            shutil.rmtree(folder)
    for file in TEMP_FILES:
        if os.path.exists(file):
            os.unlink(file)
    for file in glob.glob("*.deb"):
        os.unlink(file)


def package():
    """
    Build a .deb file
    """
    clean()

    now = datetime.datetime.now(pytz.timezone("Europe/London"))
    version = now.strftime("%Y%m%d%H%M%S")

    _update_python_package_version(version)
    _update_debian_changelog(now, version)

    print "Collecting static files"
    api.local("src/manage.py collectstatic --noinput")

    print "Building package in Vagrant box"
    api.local('vagrant up packaging')
    api.local('vagrant ssh packaging -- "cd /vagrant/ && sudo dpkg-buildpackage -us -uc"')

    # dpkg-buildpackage creates the .deb file in the root folder (/) on the
    # file system. We need to move that into the shared folder (/vagrant) so we
    # can access it from the host machine.
    api.local('vagrant ssh packaging -- "sudo mv /*.deb /vagrant/debian/dist/"')


def _update_python_package_version(version):
    print "Updating python package version"
    version_file = "src/%s/version.py" % PACKAGE
    with open(version_file, "w") as f:
        f.write("__version__ = '%s'" % version)


def _update_debian_changelog(now, version):
    print "Updating debian changelog"
    replacements = {
        'PACKAGE': PACKAGE,
        'VERSION': version,
        'DESCRIPTION': "Built from commit %s" % _commit_sha(),
        'BUILD_DATE': now.strftime("%a, %d %b %Y %H:%M:%S %z"),
        'AUTHOR_EMAIL': 'dev@example.com',
        'AUTHOR': 'Fabric',
    }
    contents = DEBIAN_CHANGELOG_TEMPLATE
    for variable, replacement in replacements.items():
        contents = contents.replace(variable, replacement)
    with open("debian/changelog", "w") as f:
        f.write(contents)


def _commit_sha():
    return api.local("git rev-parse HEAD", capture=True)[:8]
