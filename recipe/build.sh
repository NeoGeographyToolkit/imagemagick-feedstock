#!/bin/bash

export CFLAGS="-I$PREFIX/include $CFLAGS"
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib $LDFLAGS"

if [[ $(uname) == Darwin ]]; then
  export CC=clang
  export CXX=clang++
  export LDFLAGS="$LDFLAGS -headerpad_max_install_names"
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
            --with-bzlib=no \
            --with-autotrace=no \
            --with-djvu=no \
            --with-dps=no \
            --with-fftw=no\
            --with-flif=no \
            --with-fpx=no \
            --with-fontconfig=no \
            --with-freetype=no \
            --with-gslib=no \
            --with-gvc=no \
            --with-heic=no \
            --with-jbig=no \
            --with-jpeg=yes \
            --with-lcms=no \
            --with-lqr=no \
            --with-ltdl=no \
            --with-lzma=yes \
            --with-magick-plus-plus=yes \
            --with-openexr=no \
            --with-jp2=yes \
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

make -j${CPU_COUNT}
# FIXME:
# The failure below seems to be associated with the option --with-gslib,
# but I could not get to turn "yes." See the logs for more info.
#
# tests/wandtest.c main 5321 non-conforming drawing primitive definition `text' @ error/draw.c/DrawImage/3269`
# make check
make install

# remove libtool files
find $PREFIX -name '*.la' -delete
