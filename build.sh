coffee -c *.coffee
pushd routes > /dev/null 2>&1
coffee -c *.coffee
popd > /dev/null 2>&1

pushd public/js > /dev/null 2>&1
coffee -c *.coffee
popd > /dev/null 2>&1
