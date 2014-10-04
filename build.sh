#!/bin/sh
# Install dependencies
npm install

if [ "$1" == "install" ]
then
    npm install --global coffee-script
fi

coffee -c *.coffee
pushd routes > /dev/null 2>&1
coffee -c *.coffee
popd > /dev/null 2>&1

pushd public/js > /dev/null 2>&1
coffee -c *.coffee
popd > /dev/null 2>&1

# Install to /usr/share/harmony-server
if [ "$1" == "install" ]
then
    mkdir -p /usr/share/harmony-server
    ./gencert.sh

    cp *.js /usr/share/harmony-server
    cp -r node_modules /usr/share/harmony-server
    cp -r public /usr/share/harmony-server
    cp -r ssl /usr/share/harmony-server
fi