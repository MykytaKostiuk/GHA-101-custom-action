FROM alpine:latest

RUN apk add --no-cache \
    bash \
    jq \
    curl && \
    which bash && \
    which curl && \
    which jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]