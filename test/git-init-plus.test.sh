#! /bin/sh
# file: examples/equality_test.sh

testGitIsInitialized()
{

    mkdir temp-test-dir
    cd temp-test-dir  || exit
    ../git-init-plus.sh
    exists=false
    if test -f ".git/hooks/commit-msg.sample"; then exists=true;fi
    assertEquals true "$exists"
    cd ..
    rm -rf temp-test-dir
}

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

testREADMEIsCreated()
{

    mkdir temp-test-dir
    cd temp-test-dir  || exit
    ../git-init-plus.sh
    exists=false
    if test -f "README.md"; then exists=true;fi
    assertEquals true "$exists"
    cd ..
    rm -rf temp-test-dir
}
