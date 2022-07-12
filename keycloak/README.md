
# Create self-signed certificate

```
openssl req -newkey rsa:2048 -nodes -keyout ./certs/localhost.key -x509 -days 3650 -out ./certs/localhost.crt -config openssl.cnf
sudo chmod 655 ./certs/*
```

# Start Keycloak with docker (https://www.keycloak.org/getting-started/getting-started-docker)

```
docker-compose up
```

# Misc

```
adb reverse tcp:8443 tcp:8443
adb push certs/localhost.crt /storage/emulated/0/Download
adb logcat *:E
keytool -list -v -keystore android/app/debug.keystore -alias androiddebugkey -storepass android -keypass android
```