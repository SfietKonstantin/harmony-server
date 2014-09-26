coffee -c *.coffee
pushd routes
coffee -c *.coffee
popd

pushd public/js
coffee -c *.coffee
popd
