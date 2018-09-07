FROM jluth/docker-clang:6.0.0
LABEL maintainer="Joel Luth (joelluth@gmail.com)"
LABEL description="sysbench from source"

#ARG DEBIAN_FRONTEND=noninteractive

ENV SYSBENCH_REL 1.0.15
ENV CC clang-6.0

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                automake \
                git \
                libaio-dev \
                libmariadbclient-dev \
                libpq-dev \
                libtool \
                make \
                pkg-config \
	&& apt-get clean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*
# pass --with-extra-ldflags="-all-static" to configure for static build
# although I can't get that to work with mysql or pgsql
RUN git clone https://github.com/akopytov/sysbench.git \
        && cd sysbench \
        && git checkout tags/"$SYSBENCH_REL" \
        && ./autogen.sh \
        && ./configure --with-mysql --with-pgsql \
	&& sed -i '/CC= $(DEFAULT_CC)/d' third_party/luajit/luajit/src/Makefile \
        && make -j \
        && make install \
	&& make clean

CMD ["/usr/local/bin/sysbench", "--version"]
