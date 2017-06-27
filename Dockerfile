FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y gcc g++ bc make
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN locale-gen en_US.UTF-8


ADD . /home/workdir

WORKDIR /home

RUN /home/workdir/mutrun.sh

