
Create self-signed certificate

$ openssl req -newkey rsa:2048 -nodes -keyout ./certs/localhost.key -x509 -days 3650 -out ./certs/localhost.crt -config openssl.cnf
$ sudo chmod 655 ./certs/*

Start Keycloak with docker (https://www.keycloak.org/getting-started/getting-started-docker)

$ docker run \
  --name keycloak \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -e KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/localhost.crt \
  -e KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/localhost.key \
  -v $PWD/certs/localhost.crt:/opt/keycloak/conf/localhost.crt \
  -v $PWD/certs/localhost.key:/opt/keycloak/conf/localhost.key \
  -p 8443:8443 \
  quay.io/keycloak/keycloak:18.0.0 \
  start-dev

$$ sudo docker-compose -f keycloak.yml up