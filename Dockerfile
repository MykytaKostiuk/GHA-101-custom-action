FROM alpine:latest

RUN apk add --no-cache \
    bash \
    jq \
    httpie && \
    which bash && \
    which http && \
    which jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]