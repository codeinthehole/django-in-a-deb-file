# Packaging a Django site as a debfile 

An example Django project which can be built and deployed as a single `.deb`
file. The package includes the project virtualenv as well as uWSGI, nginx and
upstart config files. Once built, the project can be installed using:

    $ gdebi helloworld_0.1-1_amd64.deb

## Building the package

To add a Python package, install it using `pip install $package` then update
`requirements.txt` using `pip-dump`.

Once installed, the python package will be stored in `/usr/share/python/$package/`

To run a `manage.py` command, use:

    $ DJANGO_SETTINGS_MODULE=helloworld.settings /usr/share/python/helloworld/bin/django-admin shell

Eg, to run migrations:

    $ /usr/share/python/helloworld# DJANGO_SETTINGS_MODULE=helloworld.settings bin/django-admin migrate

## Package structure

Python packages are stored in `/usr/share/python/$package`. 

Static files are stored in `/usr/share/static/` and are served directly by
Nginx.

## Useful commands

List contents of a package with 

    $ dpkg -c file.deb

uWSGI is configured to provide statistics and the uwsgitop commmand is included
in the package. To view what uWSGI is doing, use:

    $ /usr/share/python/helloworld/bin/uwsgitop /tmp/uwsgi.stats.sock
