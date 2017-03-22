FROM debian:jessie

RUN apt-get update

RUN apt-get install -y curl build-essential unzip clang

RUN curl http://lcamtuf.coredump.cx/afl/releases/afl-2.39b.tgz | \
    tar -C /var/local/ -xzf - && cd /var/local/afl-2.39b && \
    make && make install
