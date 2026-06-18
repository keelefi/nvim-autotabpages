FROM ubuntu:24.04

# install dependencies for luarocks and for building LuaLS
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        lua5.1 \
        luarocks \
        ninja-build \
        gcc-13 \
        git

# install luarocks
#RUN ln -s /lib/x86_64-linux-gnu/librt.so.1 /usr/lib/x86_64-linux-gnu/librt.so
RUN luarocks install busted RT_LIBDIR=/lib/x86_64-linux-gnu

# change user
RUN groupadd -r user && useradd -r -g user user
USER user

WORKDIR /data

# build Lua Language Server
ARG LUA_LS_VERSION=3.18.2
RUN git clone https://github.com/LuaLS/lua-language-server
WORKDIR /data/lua-language-server
RUN git checkout ${LUA_LS_VERSION}
RUN chmod +x make.sh
RUN ./make.sh
ENV PATH="$PATH:/data/lua-language-server/bin"

RUN mkdir /data/nvim-autotabpages
WORKDIR /data/nvim-autotabpages

RUN mkdir /data/nvim-autotabpages/ci
RUN mkdir /data/nvim-autotabpages/ci/LuaCATS
RUN git clone https://github.com/LuaCATS/luassert.git /data/nvim-autotabpages/ci/LuaCATS/luassert
RUN git clone https://github.com/LuaCATS/busted.git /data/nvim-autotabpages/ci/LuaCATS/busted

COPY .luarc-ci.json /data/nvim-autotabpages
COPY run-tests.sh /data/nvim-autotabpages
COPY tests /data/nvim-autotabpages/tests
COPY lua /data/nvim-autotabpages/lua

ENV LUA_PATH=/data/nvim-autotabpages/lua/?.lua

CMD ["busted", "--pattern=\".*-test%.lua\"", "--verbose", "tests/autotabpages"]
