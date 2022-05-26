#!/usr/bin/env bash
set -eu

cd certs
org=localhost
domain=localhost

sudo trust anchor --remove "$domain".crt || true

openssl genpkey -algorithm RSA -out "$domain".key

openssl req -x509 -key "$domain".key -out "$domain".crt \
    -subj "/CN=$domain/O=$org" \
    -config <(cat /etc/ssl/openssl.cnf - <<END
[ x509_ext ]
basicConstraints = critical,CA:true
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
subjectAltName = DNS:$domain
END
    ) -extensions x509_ext

sudo trust anchor "$domain".crt