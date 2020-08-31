FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y python3 git \
    && rm -rf /var/apt/sources/list/*

COPY build/* build/
COPY config.mcf config.mcf

RUN mkdir /artifacts \
    && ln -snf ../conf build/.

RUN build/mcf -f config.mcf

RUN rm -rf openembedded-core/meta/conf/machine/qemuarm.conf
COPY qemuarm.conf openembedded-core/meta/conf/machine/
ENV DEFAULTTUNE cortexa9-vfpv3
RUN openembedded-core/oe-init-build-env && cd - && bitbake ros-foxy-core
