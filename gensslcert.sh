#!/bin/sh

# create self-signed server certificate:

read -p "Enter your domain [www.example.com]: " DOMAIN

# create CA certification

echo "Create server key..."

openssl genrsa -des3 -out ca.key 2048

echo "Create server certificate signing request..."

openssl req -new -x509 -days 7305 -key ca.key -out ca.crt

# create website's CA

openssl genrsa -des3 -out $DOMAIN.pem 1024

openssl rsa -in $DOMAIN.pem -out $DOMAIN.key

openssl req -new -key $DOMAIN.pem -out $DOMAIN.csr

mkdir -p demoCA/newcerts
touch demoCA/index.txt
touch demoCA/serial
echo "01" > demoCA/serial

openssl ca -policy policy_anything -days 1460 -cert ca.crt -keyfile ca.key -in $DOMAIN.csr -out $DOMAIN.crt

echo "TODO:"
echo "Copy $DOMAIN.crt to /etc/nginx/ssl/$DOMAIN.crt"
echo "Copy $DOMAIN.key to /etc/nginx/ssl/$DOMAIN.key"
echo "Add configuration in nginx:"
echo "server {"
echo "    ..."
echo "    listen 443 ssl;"
echo "    ssl_certificate     /etc/nginx/ssl/$DOMAIN.crt;"
echo "    ssl_certificate_key /etc/nginx/ssl/$DOMAIN.key;"
echo "}"
