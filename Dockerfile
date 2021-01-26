FROM debian:buster-slim

LABEL maintainer="Marlon Leerkotte <marlon@leerkotte.net>"

ARG DEBIAN_FRONTEND=noninteractive

ENV IMAPSYNC_UID=51337 \
    IMAPSYNC_GID=51337

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libauthen-ntlm-perl libcgi-pm-perl libcrypt-openssl-rsa-perl \
        libdata-uniqid-perl libencode-imaputf7-perl \
        libfile-copy-recursive-perl libfile-tail-perl \
        libio-socket-inet6-perl libio-socket-ssl-perl libio-tee-perl \
        libhtml-parser-perl libjson-webtoken-perl libmail-imapclient-perl \
        libparse-recdescent-perl libmodule-scandeps-perl libreadonly-perl \
        libregexp-common-perl libsys-meminfo-perl libterm-readkey-perl \
        libtest-mockobject-perl libtest-pod-perl libunicode-string-perl \
        liburi-perl libwww-perl libtest-nowarnings-perl libtest-deep-perl \
        libtest-warn-perl make cpanminus curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r build -g $IMAPSYNC_GID \
    && useradd --no-log-init -m -r -u $IMAPSYNC_UID -g $IMAPSYNC_GID imapsync \
    && curl -LJO https://github.com/imapsync/imapsync/archive/1.977.tar.gz \
    && tar -xzvf imapsync-1.977.tar.gz \
    && chmod +x imapsync-1.977/imapsync \
    && cp imapsync-1.977/imapsync /usr/bin/imapsync

USER imapsync

ENTRYPOINT ["imapsync"]
