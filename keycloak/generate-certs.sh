#!/usr/bin/env bash
set -eu

org=localhost
domain=localhost

sudo trust anchor --remove ./certs/"$domain".crt || true

openssl genpkey -algorithm RSA -out ./certs/"$domain".key

openssl req -x509 -days 365 -key ./certs/"$domain".key -out ./certs/"$domain".crt \
    -subj "/CN=$domain/O=$org" \
    -config <(cat /etc/ssl/openssl.cnf - <<END
[ x509_ext ]
basicConstraints = critical,CA:true
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
subjectAltName = @alternate_names
[ alternate_names ]
DNS.1      = $domain
IP.1       = 127.0.0.1
IP.2       = 10.0.2.2
END
    ) -extensions x509_ext

sudo trust anchor ./certs/"$domain".crt || true

cp ./certs/"$domain".crt ../mobile-app/android/app/src/main/res/raw/ -R

echo "Para instalar o certificado .crt no app, siga o tutorial abaixo:"
echo "https://medium.com/@noumaan/ssl-app-dev-a2923d5113c6"