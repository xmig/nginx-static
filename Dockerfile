FROM drogonframework/drogon
# really it would be any suitable ubuntu / C++ based image

USER root

RUN apt-get update -yqq \
    && apt-get install -yqq libpcre3 libpcre3-dev libssl-dev upx

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN mkdir -p /nginx-src
RUN (cd /nginx-src && wget https://nginx.org/download/nginx-1.20.1.tar.gz && tar -xzf nginx-1.20.1.tar.gz)
RUN (cd /nginx-src && wget http://www.zlib.net/zlib-1.2.11.tar.gz && tar -xzf zlib-1.2.11.tar.gz)
RUN (cd /nginx-src && wget https://sourceforge.net/projects/pcre/files/pcre/8.21/pcre-8.21.tar.gz && tar -xzf pcre-8.21.tar.gz)

# see https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/ for nginx configure

ENTRYPOINT (cd /nginx-src/nginx-1.20.1 && ./configure \
    --prefix=/nginx --with-cc-opt="-static -static-libgcc" \
    --with-ld-opt="-static" --with-cpu-opt=generic \
    --with-mail --with-poll_module --with-select_module \
    --with-select_module --with-poll_module \
    --with-http_addition_module --with-http_sub_module --with-http_dav_module \
    --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module \
    --with-http_gzip_static_module --with-http_auth_request_module \
    --with-http_random_index_module --with-http_secure_link_module \
    --with-http_degradation_module --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-zlib=../zlib-1.2.11 \
    --with-pcre=../pcre-8.21 \
    --with-pcre-jit \
    && make \
    && strip objs/nginx \
    && upx objs/nginx \
    && cp objs/nginx /nginx \
    && cp -r conf /nginx \
    && echo "DONE" )

#exec /opt/jboss/keycloak/bin/standalone.sh $SYS_PROPS $@
#exit $?

