FROM alpine
LABEL maintainer <contact@ilyaglotov.com>

ENV EMPIRE_USER empire
ENV STAGING_KEY RANDOM

# Reference: https://github.com/EmpireProject/Empire/blob/master/setup/install.sh
RUN apk update \
  && apk add --no-cache fts-dev \
                        git \
                        libcap \
                        libffi-dev \
                        libxml2-dev \
                        openjdk8 \
                        openssl-dev \
                        py-pip \
                        python \
                        python-dev \
                        swig \
                        \
  && ln -s /usr/lib/jvm/default-jvm/bin/javac /usr/bin/javac \
  && apk add --virtual .build-deps \
                        autoconf \
                        build-base \
                        linux-headers \
                        \
  && rm -rf /var/cache/apk/*

# Install xar from sources
RUN git clone --depth=1 \
              --branch=master \
              https://github.com/mackyle/xar.git \
  && cd /xar/xar \
  && ./autogen.sh --noconfigure \
  && ./configure LDFLAGS=-lfts \
  && make \
  && make install \
  && cd / \
  && rm -rf /xar

# Install bomutils from sources
RUN git clone --depth=1 \
              --branch=master \
              https://github.com/hogliux/bomutils.git \
  && cd bomutils \
  && make \
  && make install \
  && chmod 755 build/bin/mkbom \
  && cp build/bin/mkbom /usr/local/bin/mkbom \
  && cd / \
  && rm -rf /bomutils

# Install Empire's python dependencies
RUN pip install cryptography \
                dropbox \
                flask \
                iptools \
                m2crypto \
                macholib \
                netifaces \
                pycrypto \
                pydispatcher \
                pyinstaller \
                pyopenssl \
                setuptools \
                zlib_wrapper \
                \
  && rm -rf /root/.cache/pip \
  && apk del .build-deps

# Clone Empire repository and clean things up
RUN git clone --depth=1 \
              --branch=master \
              https://github.com/EmpireProject/Empire.git \
              /empire \
  && rm -rf /empire/.git \
  && apk del git

# Add ability to Empire listeners to bind to low-numbered ports without root
RUN setcap cap_net_bind_service=+eip /usr/bin/python2.7 \
  && adduser -D $EMPIRE_USER \
  && chown -R $EMPIRE_USER /empire

USER $EMPIRE_USER

# Setup database
RUN cd /empire/setup \
  && python setup_database.py

RUN mkdir /empire/downloads
VOLUME /empire/downloads
EXPOSE 80 443 1337 8080
WORKDIR /empire

CMD ["python", "./empire"]
