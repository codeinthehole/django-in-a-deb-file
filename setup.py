#!/usr/bin/env python
from setuptools import setup, find_packages

setup(
    name='helloworld',
    version='0.1',
    package_dir={'': 'src'},
    packages=['helloworld'],
    include_package_data=True,
)
