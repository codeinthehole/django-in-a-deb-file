#!/usr/bin/env python
from setuptools import setup, find_packages

PACKAGE_NAME = "helloworld"

exec(open('src/%s/version.py' % PACKAGE_NAME).read())

setup(
    name=PACKAGE_NAME,
    version=__version__,
    package_dir={'': 'src'},
    packages=[PACKAGE_NAME],
    include_package_data=True,
)
