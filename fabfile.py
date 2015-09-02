from fabric import api
import os

PACKAGE = "helloworld"

TEMP_FOLDERS = (
    "build", "dist", "usr/share/static", "debian/%s" % PACKAGE
)

TEMP_FILES = (
    "debian/%s.debhelper.log" % PACKAGE,
    "debian/changelog",
    "debian/files",
    "src/%s/version.py" % PACKAGE,
)


def clean():
    for folder in TEMP_FOLDERS:
        api.local("rm -rf %s" % folder)
    for file in TEMP_FILES:
        if os.path.exists(file):
            api.local("rm %s" % file)
