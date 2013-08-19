#!/bin/bash

# /bin/sh on Solaris is not a POSIX compatible shell, but /usr/bin/ksh is.
if [ `uname -s` = 'SunOS' -a "${POSIX_SHELL}" != "true" ]; then
    POSIX_SHELL="true"
    export POSIX_SHELL
    exec /usr/bin/ksh $0 $@
fi
unset POSIX_SHELL # clear it so if we invoke other scripts, they run as ksh as well

set -e

LIBUV_REPO=git://github.com/joyent/libuv.git
LIBUV_BRANCH="master"
LIBUV_DIR=libuv-`basename $LIBUV_BRANCH`

[ `basename $PWD` != "c_src" ] && cd c_src

BASEDIR="$PWD"

which gmake 1>/dev/null 2>/dev/null && MAKE=gmake
MAKE=${MAKE:-make}

export CFLAGS="$CFLAGS -I $BASEDIR/system/include"
export CXXFLAGS="$CXXFLAGS -I $BASEDIR/system/include"
export LDFLAGS="$LDFLAGS -L$BASEDIR/system/lib"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BASEDIR/system/lib:$LD_LIBRARY_PATH"

get_libuv ()
{
    if [ -d $BASEDIR/$LIBUV_DIR/.git ]; then
        (cd $BASEDIR/$LIBUV_DIR && git pull -u) || exit 1
    else
        if [ "X$LIBUV_REF" != "X" ]; then
            git clone ${LIBUV_REPO} ${LIBUV_DIR} && \
                (cd $BASEDIR/$LIBUV_DIR && git checkout refs/$LIBUV_REF || exit 1)
        else
            git clone ${LIBUV_REPO} ${LIBUV_DIR} && \
		[ "X$LIBUV_BRANCH" = "Xmaster" ] || \
                (cd $BASEDIR/$LIBUV_DIR && git checkout -b $LIBUV_BRANCH origin/$LIBUV_BRANCH || exit 1)
        fi
        if [ ! -d ${LIBUV_DIR}/build/gyp ]; then
            (cd $BASEDIR/$LIBUV_DIR && svn co http://gyp.googlecode.com/svn/trunk build/gyp)
        fi
    fi
    [ -d $BASEDIR/$LIBUV_DIR ] || (echo "Missing libuv source directory" && exit 1)
    (cd $BASEDIR/$LIBUV_DIR
        [ -e $BASEDIR/libuv-build.patch ] && \
            (patch -p1 --forward < $BASEDIR/libuv-build.patch || exit 1 )
        python2 ./gyp_uv -f make >/dev/null 2>&1 || exit 1
        ./autogen.sh || exit 1
        [ -e $BASEDIR/$LIBUV_DIR/Makefile ] && (cd $BASEDIR/$LIBUV_DIR && $MAKE distclean)
        libuv_configure;
    )
}

libuv_configure ()
{
    (cd $BASEDIR/$LIBUV_DIR
        CFLAGS+=-g ./configure --with-pic --prefix=${BASEDIR}/system || exit 1)
}

get_deps ()
{
    get_libuv;
}

update_deps ()
{
    if [ -d $BASEDIR/$LIBUV_DIR/.git ]; then
        (cd $BASEDIR/$LIBUV_DIR
            if [ "X$LIBUV_VSN" == "X" ]; then
                git pull -u || exit 1
            else
                git checkout $LIBUV_VSN || exit 1
            fi
        )
    fi
}

build_libuv ()
{
    libuv_configure;
    (cd $BASEDIR/$LIBUV_DIR && $MAKE -j && $MAKE install)
}


case "$1" in
    clean)
        rm -rf system $LIBUV_DIR
        rm -f ${BASEDIR}/../priv/libuv-*.so
        ;;

    test)
        (cd $BASEDIR/$LIBUV_DIR && $MAKE -j test)
        ;;

    update-deps)
        update-deps;
        ;;

    get-deps)
        get_deps;
        ;;

    *)
        [ -d $LIBUV_DIR ] || get_libuv;

        # Build libuv
        [ -d $BASEDIR/$LIBUV_DIR ] || (echo "Missing libuv source directory" && exit 1)
        [ -f $BASEDIR/system/lib/libuv.so.11.0.0 ] || build_libuv;
        cp -p -P $BASEDIR/system/lib/libuv.so* ${BASEDIR}/../priv
        ;;
esac

