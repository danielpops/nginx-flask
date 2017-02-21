FROM ubuntu:xenial
MAINTAINER Daniel Popescu <danielpops@gmail.com>

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        python-pip \
        python-setuptools \
        vim \
    && apt-get clean

RUN pip install flask

ADD ./app.py /opt/example/app.py
ADD ./run.sh /opt/example/run.sh

WORKDIR /opt/example

EXPOSE 5001

ENTRYPOINT /opt/example/run.sh
