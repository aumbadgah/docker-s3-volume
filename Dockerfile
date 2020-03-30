FROM alpine:3.10

RUN apk --no-cache add \
    bash \
    py3-pip \
    && pip3 install \
    --no-cache-dir \
    awscli

COPY bin/sync /usr/local/bin/sync
COPY bin/s3.sh /usr/local/bin/s3

VOLUME /data
WORKDIR /data

ENV REMOTE=s3://docker-s3-volume

CMD sync /data $REMOTE
