FROM python:2-alpine
LABEL maintainer <contact@ilyaglotov.com>

ENV EMPIRE_USER empire
ENV STAGING_KEY RANDOM

# Reference: https://github.com/EmpireProject/Empire/blob/2.0_beta/setup/install.sh
RUN apk update && \
    apk add --no-cache py-pip \
    python-dev \
    openssl-dev \
    swig \
    libxml2-dev \
    libffi-dev \
    libcap \
    openjdk8 && \
    ln -s /usr/lib/jvm/default-jvm/bin/javac /usr/bin/javac

RUN apk add --virtual .build-deps \
    build-base \
    git \
    linux-headers

RUN git clone --depth=1 \
    --branch=master \
    https://github.com/EmpireProject/Empire.git \
    /empire \
  && rm -rf /empire/.git

RUN pip install setuptools \
    pycrypto \
    iptools \
    pydispatcher \
    flask \
    macholib \
    cryptography \
    pyopenssl \
    pyinstaller \
    zlib_wrapper \
    netifaces \
    m2crypto \
    dropbox \
  && apk del .build-deps

# Add ability to Empire listeners to bind to low-numbered ports without root
RUN setcap cap_net_bind_service=+eip /usr/local/bin/python2.7 && \
    adduser -D $EMPIRE_USER && \
    chown -R $EMPIRE_USER /empire

USER $EMPIRE_USER

# Setup database
RUN cd /empire/setup && \
    python setup_database.py

RUN mkdir /empire/downloads
VOLUME /empire/downloads
EXPOSE 80 443 8080
WORKDIR /empire

ENTRYPOINT ["python", "./empire"]
