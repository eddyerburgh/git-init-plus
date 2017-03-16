#! /bin/sh
# file: examples/equality_test.sh

testLicenseIsCreated()
{

    mkdir temp-test-dir
    cd temp-test-dir  || exit
    ../git-init-plus.sh
    exists=false
    if test -f "LICENSE"; then exists=true;fi
    assertEquals true "$exists"
    cd ..
    rm -rf temp-test-dir
}
