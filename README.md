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

## Configuration

Environment variables are read from an optional `/etc/django_app.env` file. By
default, the `settings.py` module looks for the following env vars:

* `SECRET_KEY`
* `DEBUG` (set this to `0` to disable debug mode)
* `ALLOWED_HOSTS` - a comma-separated list of domains

Use your favourite configuration management software to put this file in place.
At a minimum, you could use an AWS "user data" script like the following:

```bash
#!/usr/bin/env bash

cat <<SETTINGS > /etc/django_app.env
DEBUG = 0
ALLOWED_HOSTS = "mydomain.com,subdomain.mydomain.com"
SECRET_KEY = "a459ckak1k23la2039ddkd"
SETTINGS
```

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

## Customising

This sample project is called "helloworld", this is the name of both:

- The Python package (hence why the package files are installed in
  `/usr/share/python/helloworld/`)

- The Debian package 

If you start with this repo, you'll want to rename the following things:

- `src/helloworld` - the Python package location, this also requires path
  changes in `etc/init/django_app.conf`, `etc/uwsgi/django_app.ini`
- `setup.py` - change the `name` kwarg
- `debian/control` - change the Debian package name
- `debian/helloworld.install`
- `debian/helloworld.postinst`
- `debian/helloworld.triggers`

## Deployment procedure

When ready to deploy, you need to bump the version:

    $ ./bump_version.sh

## Installing 

Use the [deb-s3](http://invalidlogic.com/2013/02/26/managing-apt-repos-on-s3/)
library to upload the `.deb` file into S3. You'll first need to create a S3
bucket that is readable by the destination server. Then run:
    
    $ deb-s3 upload --bucket <bucket-name> <package>.deb

to upload the package. On the destination server, append:

    deb https://<bucket-name>.s3.amazonaws.com stable main

to `/etc/apt/sources.list` then install using:

    $ apt-get update
    $ apt-get install <package>


