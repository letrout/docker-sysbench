FROM debian:9.4-slim
LABEL maintainer="Joel Luth (joelluth@gmail.com)"
LABEL description="sysbench from source"

#ARG DEBIAN_FRONTEND=noninteractive

ENV SYSBENCH_REL 1.0.14

RUN apt-get update && apt-get install -y \
                automake \
                git \
                libaio-dev \
                libmariadbclient-dev \
                libpq-dev \
                libtool \
                make \
                pkg-config
# pass --with-extra-ldflags="-all-static" to configure for static build
# although I can't get that to work with mysql or pgsql
RUN git clone https://github.com/akopytov/sysbench.git && \
        cd sysbench && \
        git checkout tags/"$SYSBENCH_REL" && \
        ./autogen.sh && \
        ./configure --with-mysql --with-pgsql && \
        make -j && \
        make install

RUN cd && rm -rf sysbench
RUN apt-get purge -y \
                automake \
                git \
                libtool \
                make \
                pkg-config && \
        apt-get -y clean && \
        apt-get -y autoremove

CMD ["/usr/local/bin/sysbench", "--version"]