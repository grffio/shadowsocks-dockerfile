#!/usr/bin/env bash

# Variables
confDir="/opt/shadowsocks"
confFile="${confDir}/shadowsocks.json"

# Generate random 8 symbols password
_randPass() {
    head -c 8 /dev/urandom | xxd -p
}

# Check environment variables
_checkEnv() {
    if [ -z "${SHADOWSOCKS_SERVER}" ]; then
        SHADOWSOCKS_SERVER="0.0.0.0"
    fi
    if [ -z "${SHADOWSOCKS_SERVER_PORT}" ]; then
        SHADOWSOCKS_SERVER_PORT="8388"
    fi
    if [ -z "${SHADOWSOCKS_METHOD}" ]; then
        SHADOWSOCKS_METHOD="chacha20-ietf-poly1305"
    fi
    if [ -z "${SHADOWSOCKS_TIMEOUT}" ]; then
        SHADOWSOCKS_TIMEOUT="7200"
    fi
    if [ -z "${SHADOWSOCKS_PASSWORD}" ]; then
        SHADOWSOCKS_PASSWORD=$(_randPass)
        echo -e "Warning: 'SHADOWSOCKS_PASSWORD' variable is not specified! Using random password: ${SHADOWSOCKS_PASSWORD}\n"
    fi
}

# Preparing system parameters
_sysPrep() {
    if [ ! -d ${confDir} ]; then
        mkdir -p ${confDir}
    fi
}

# Creating config file from variables
_configCreate() {
    jo -p server=${SHADOWSOCKS_SERVER}           \
          server_port=${SHADOWSOCKS_SERVER_PORT} \
          method=${SHADOWSOCKS_METHOD}           \
          password=${SHADOWSOCKS_PASSWORD}       \
          timeout=${SHADOWSOCKS_TIMEOUT} > ${confFile}
}

# Print client config
_printClientConfig() {
    echo -e "\n#=== Client Configs Start ===#"
    jo -p server="### CHANGEME ###"          \
            server_port="### CHANGEME ###"   \
            local_address="0.0.0.0"          \
            local_port="1080"                \
            method=${SHADOWSOCKS_METHOD}     \
            password=${SHADOWSOCKS_PASSWORD} \
            timeout=${SHADOWSOCKS_TIMEOUT}
    echo -e "#=== Client Configs End ===#\n"
}

# Starting Shadowsocks
_startShadowsocks() {
    exec /usr/local/bin/ssserver --config ${confFile}
}

_checkEnv
_sysPrep
_configCreate
_printClientConfig
_startShadowsocks
