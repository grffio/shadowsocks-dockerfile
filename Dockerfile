FROM rust:1.56-alpine as builder
ARG SHADOWSOCKS_VER=1.12.2
WORKDIR /shadowsocks
RUN adduser -D -g '' appuser
RUN apk add --update curl make libc-dev
RUN curl -LO https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v${SHADOWSOCKS_VER}.tar.gz && \
    tar -xzf v${SHADOWSOCKS_VER}.tar.gz -C /shadowsocks --strip-components=1
RUN cargo build --release

FROM alpine:3.14
RUN apk add --update tini bash jo tzdata ca-certificates && \
    rm -rf /var/cache/apk/*
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /shadowsocks/target/release/ssserver /usr/local/bin/
COPY --from=builder /shadowsocks/target/release/ssurl /usr/local/bin/
COPY --from=builder /shadowsocks/target/release/ssmanager /usr/local/bin/
COPY --from=builder /shadowsocks/target/release/sslocal /usr/local/bin/
COPY ./run.sh /usr/local/bin/
RUN mkdir /opt/shadowsocks && chown 1000:1000 /opt/shadowsocks
VOLUME [ "/opt/shadowsocks" ]
USER appuser
EXPOSE 8388/tcp
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["run.sh"]
