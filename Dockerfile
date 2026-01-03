FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y libengine-gost-openssl1.1 openssl && \
    rm -rf /var/lib/apt/lists/*

RUN echo "openssl_conf = openssl_def" > /etc/ssl/openssl.cnf && \
    echo "\n[openssl_def]" >> /etc/ssl/openssl.cnf && \
    echo "engines = engine_section" >> /etc/ssl/openssl.cnf && \
    echo "\n[engine_section]" >> /etc/ssl/openssl.cnf && \
    echo "gost = gost_section" >> /etc/ssl/openssl.cnf && \
    echo "\n[gost_section]" >> /etc/ssl/openssl.cnf && \
    echo "engine_id = gost" >> /etc/ssl/openssl.cnf && \
    echo "dynamic_path = $(find /usr/lib -name gost.so)" >> /etc/ssl/openssl.cnf && \
    echo "default_algorithms = ALL" >> /etc/ssl/openssl.cnf && \
    echo "CRYPT_PARAMS = id-Gost28147-89-CryptoPro-A-ParamSet" >> /etc/ssl/openssl.cnf

RUN openssl ciphers | tr ':' '\n' | grep GOST

RUN mkdir -p /app/data /app/keys /app/scripts

COPY scripts/ /app/scripts/

RUN chmod +x /app/scripts/*.sh

WORKDIR /app

ENTRYPOINT ["/app/scripts/entrypoint.sh"]

CMD ["help"]