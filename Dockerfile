FROM ubuntu:24.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        lua5.1 \
        luarocks

RUN luarocks install busted

WORKDIR /data
COPY run-tests.sh /data
COPY tests /data/tests
COPY lua /data/lua

ENV LUA_PATH=/data/lua/?.lua

CMD ["busted", "--pattern=\"test-.*%.lua\"", "--verbose", "tests"]
