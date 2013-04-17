#!/bin/bash
# Recent change made greenlet not compatible with python-for-android yet.
# Only h264+aac build are working.

VERSION_greenlet=
URL_greenlet=https://github.com/python-greenlet/greenlet/archive/master.zip
DEPS_greenlet=(python)
MD5_greenlet=
BUILD_greenlet=$BUILD_PATH/greenlet/master
RECIPE_greenlet=$RECIPES_PATH/greenlet

function prebuild_greenlet() {
    cd $BUILD_greenlet
    # if [ ! -d greenlet ]; then
    #     try mv master greenlet
    # fi
}

function build_greenlet() {
    if [ -d "$BUILD_PATH/python-install/lib/python2.7/site-packages/greenlet" ]; then
        return
    fi

    cd $BUILD_greenlet


    # build greenlet
    export NDK=$ANDROIDNDK

    push_arm

    export LDFLAGS="$LDFLAGS -L$LIBS_PATH"
    export LDSHARED="$LIBLINK"

    # build python extension
    $BUILD_PATH/python-install/bin/python.host setup.py build_ext
    try find . -iname '*.pyx' -exec cython {} \;
    try $BUILD_PATH/python-install/bin/python.host setup.py build_ext -v
    try find build/lib.* -name "*.o" -exec $STRIP {} \;
    try $BUILD_PATH/python-install/bin/python.host setup.py install -O2

    echo "$BUILD_PATH/python-install=" $BUILD_PATH/python-install
    # try rm -rf $BUILD_PATH/python-install/lib/python*/site-packages/kivy/tools

    echo "************", $LDSHARED
    unset LDSHARED

    pop_arm
}

function postbuild_greenlet() {
    true
}
