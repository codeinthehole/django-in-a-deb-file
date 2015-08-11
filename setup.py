#!/usr/bin/env python
from setuptools import setup, find_packages
import os

PACKAGE_NAME = "helloworld"
VERSION_FILEPATH = "src/%s/version.py" % PACKAGE_NAME

if os.path.exists(VERSION_FILEPATH):
    exec(open(VERSION_FILEPATH).read())
else:
    __version__ = '0.1'

setup(
    name=PACKAGE_NAME,
    version=__version__,
    package_dir={'': 'src'},
    packages=[PACKAGE_NAME],
    include_package_data=True,
)
