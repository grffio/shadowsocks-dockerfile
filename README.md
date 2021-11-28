# shadowsocks-dockerfile
Dockerfile for Shadowsocks fast tunnel proxy on Alpine Linux

Features
--------
- Automatic creation of a configuration file

Build
-----
```
$ docker build -t grffio/shadowsocks .
```
- Supported Args: `SHADOWSOCKS_VER=`

Quick Start
-----------
```
$ docker run --name shadowsocks -d -p 8388:8388/tcp         \
             -e SHADOWSOCKS_METHOD="chacha20-ietf-poly1305" \
             -e SHADOWSOCKS_TIMEOUT="7200"                  \
             grffio/shadowsocks
```
- Supported Environment variables:
  - `SHADOWSOCKS_SERVER`      - Server listen on (default: 0.0.0.0)
  - `SHADOWSOCKS_SERVER_PORT` - Server port number (default: 8388)
  - `SHADOWSOCKS_METHOD`      - Encryption method (default: chacha20-ietf-poly1305)
  - `SHADOWSOCKS_TIMEOUT`     - TCP socket (server) or connection (client) timeout in seconds (default: 7200)
  - `SHADOWSOCKS_PASSWORD`    - A password used to encrypt transfer (default: auto generation)

- Exposed Ports:
  - 8388/tcp

An example how to use with docker-compose [shadownet-compose](https://github.com/grffio/shadownet-compose)
