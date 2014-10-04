#!/bin/sh

# CA

mkdir ssl > /dev/null 2>&1
cd ssl

openssl genrsa -des3 -out harmony-ca.key -passout pass:harmony-ca-key 1024 > /dev/null 2>&1
openssl req -new -key harmony-ca.key -out harmony-ca.csr -passin pass:harmony-ca-key -subj '/C=FR/ST=Ile de France/L=Paris/CN=Harmony project'  > /dev/null 2>&1
openssl x509 -req -days 365 -in harmony-ca.csr -signkey harmony-ca.key -out harmony-ca.crt -passin pass:harmony-ca-key  > /dev/null 2>&1

# Server
openssl genrsa -des3 -out harmony-server.key -passout pass:harmony-server-key 1024  > /dev/null 2>&1
openssl req -new -key harmony-server.key -out harmony-server.csr -passin pass:harmony-server-key -subj '/C=FR/ST=Ile de France/L=Paris/CN=Harmony project'  > /dev/null 2>&1
cp harmony-server.key harmony-server.key.orig
openssl rsa -in harmony-server.key.orig -out harmony-server.key -passin pass:harmony-server-key  > /dev/null 2>&1
openssl x509 -req -days 365 -in harmony-server.csr -signkey harmony-server.key -out harmony-server.crt -passin pass:harmony-server-key  > /dev/null 2>&1

# Public 
openssl rsa -in harmony-server.key -pubout -out harmony-server-key.pub > /dev/null 2>&1