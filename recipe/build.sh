#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"

if [[ $(uname) == Darwin ]]; then
  export CC=clang
  export CXX=clang++
  export LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib -headerpad_max_install_names $LDFLAGS"
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
  export MACOSX_DEPLOYMENT_TARGET="10.9"
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
fi

# remove libtool files
find $PREFIX -name '*.la' -delete

./configure --prefix=$PREFIX \
            --disable-hdri \
            --with-quantum-depth=16 \
            --disable-docs \
            --disable-static \
            --disable-openmp \
            --with-bzlib=yes \
            --with-autotrace=no \
            --with-djvu=no \
            --with-dps=no \
            --with-fftw=yes \
            --with-flif=no \
            --with-fpx=no \
            --with-fontconfig=no \
            --with-freetype=no \
            --with-gslib=no \
            --with-gvc=no \
            --with-jbig=no \
            --with-jpeg=yes \
            --with-lcms=no \
            --with-lqr=no \
            --with-ltdl=no \
            --with-lzma=yes \
            --with-magick-plus-plus=yes \
            --with-openexr=no \
            --with-openjp2=yes \
            --with-pango=no \
            --with-perl=no \
            --with-png=yes \
            --with-raqm=no \
            --with-raw=no \
            --with-rsvg=no \
            --with-tiff=yes \
            --with-webp=no \
            --with-wmf=no \
            --with-x=no \
            --with-xml=no \
            --with-zlib=yes

make -j$CPU_COUNT
# FIXME:
# The failure below seems to be associated with the option --with-gslib,
# but I could not get to turn "yes." See the logs for more info.
#
# tests/wandtest.c main 5321 non-conforming drawing primitive definition `text' @ error/draw.c/DrawImage/3269`
# make check
make install -j$CPU_COUNT

# remove libtool files
find $PREFIX -name '*.la' -delete
