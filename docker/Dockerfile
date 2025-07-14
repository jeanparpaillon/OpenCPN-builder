FROM cimg/android:2023.12-ndk AS builder_android_armhf

ARG UID
ARG GID

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

USER root:root

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt -q update
RUN apt install cmake git gettext python3-pip
RUN python3 -m pip install --user --force-reinstall -q pip setuptools
RUN apt remove python3-six python3-colorama python3-urllib3
RUN python3 -m pip install --user cloudsmith-cli cryptography

ADD build-corelibs-android_armhf.sh /scripts/build-corelibs-android_armhf.sh
RUN chmod a+rx /home/circleci
RUN install -d -o $UID -g $GID /src /build

USER $UID:$GID
WORKDIR /src

CMD /scripts/build-corelibs-android_armhf.sh