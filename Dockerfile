FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y gcc g++ bc make

ADD . /home/workdir

WORKDIR /home

RUN /home/workdir/mutrun.sh

