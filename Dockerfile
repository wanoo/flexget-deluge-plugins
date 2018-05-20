FROM python:2.7
MAINTAINER Erwan Rougeux <e.rougeuxgmail.com>

# a JS runtime, such as node, is required for cfscrape, see https://github.com/Anorov/cloudflare-scrape
RUN apt-get update && apt-get install -y nodejs gcc libboost-all-dev python-libtorrent

VOLUME ["/usr/src/app"]

WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app

# prepare virtualenv
RUN mkdir /usr/src/app/compile \
      && cd /usr/src/app/compile \
      && wget 'http://download.deluge-torrent.org/source/deluge-1.3.13.tar.gz' -O release.tgz \
      && tar xzvf release.tgz \
      && cd deluge-1.3.13/ \
      && pip install twisted[tls] chardet mako pyxdg service_identity pyopenssl pygeoip \
      && python setup.py build \
      && python setup.py install \
      && cd /usr/src/app \
      && pip install -r requirements.txt

# this is the default command, should work fine for most cases, easy to override anyway
CMD ["/usr/local/bin/flexget", "--loglevel", "info", "daemon", "start"]