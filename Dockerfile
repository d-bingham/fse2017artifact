FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y gcc g++ bc make

ADD . /home/workdir

WORKDIR /home

RUN /home/workdir/mutrun.sh

