#!/bin/bash

export GITHUB_WORKSPACE="$(pwd)"
export CROSS_OVER_VERSION="25.1.0"
export CROSS_OVER_SOURCE_URL=https://media.codeweavers.com/pub/crossover/source/crossover-sources-${CROSS_OVER_VERSION}.tar.gz
export CROSS_OVER_LOCAL_FILE=crossover-${CROSS_OVER_VERSION}
export WINE_CONFIGURE="${GITHUB_WORKSPACE}"/sources/wine/configure
export BUILDROOT="${GITHUB_WORKSPACE}"/build
export INSTALLROOT="${GITHUB_WORKSPACE}"/install
export WINE_INSTALLATION=wine-cx${CROSS_OVER_VERSION}

eval "$(/usr/local/bin/brew shellenv)"
alias brew="arch -x86_64 brew"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/local/opt/libpcap/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libpcap/lib/pkgconfig:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export CC="clang -arch x86_64"
export CXX="clang++ -arch x86_64"
export i386_CC="i686-w64-mingw32-gcc"
export x86_64_CC="x86_64-w64-mingw32-gcc"
export CPATH="/usr/local/include"
export LIBRARY_PATH="/usr/local/lib"
export MACOSX_DEPLOYMENT_TARGET="26.0"
export OPTFLAGS="-O2"
export CFLAGS="${OPTFLAGS} -Wno-deprecated-declarations -Wno-format"
export CROSSCFLAGS="${OPTFLAGS} -Wno-incompatible-pointer-types"
export CPPFLAGS="-I/usr/local/opt/llvm/include -I/usr/local/opt/bison/include"
export LDFLAGS="-L/usr/local/opt/llvm/lib -L/usr/local/opt/bison/lib -Wl,-headerpad_max_install_names -Wl,-rpath,@loader_path/../../ -Wl,-rpath,/usr/local/lib -Wl,-rpath,/opt/X11/lib"
export ac_cv_lib_soname_vulkan=""
export DYLD_FALLBACK_LIBRARY_PATH="${DYLD_FALLBACK_LIBRARY_PATH}:/usr/lib:/usr/X11/lib"

if [[ ! -f ${CROSS_OVER_LOCAL_FILE}.tar.gz ]]; then
    curl -o ${CROSS_OVER_LOCAL_FILE}.tar.gz ${CROSS_OVER_SOURCE_URL}
    if [[ -d "${GITHUB_WORKSPACE}/sources" ]]; then
        rm -rfv "${GITHUB_WORKSPACE}"/sources
    fi
    tar xvf ${CROSS_OVER_LOCAL_FILE}.tar.gz
fi

cp "${GITHUB_WORKSPACE}"/distversion.h "${GITHUB_WORKSPACE}"/sources/wine/programs/winedbg/distversion.h

brew update
brew upgrade
brew install bison mingw-w64 llvm lld gettext gstreamer pkgconfig freetype gnutls molten-vk sdl2

mkdir -p "${BUILDROOT}"/winecx-${CROSS_OVER_VERSION}
pushd "${BUILDROOT}"/winecx-${CROSS_OVER_VERSION}
${WINE_CONFIGURE} \
    --build=x86_64-apple-darwin \
    --prefix= \
    --disable-tests \
    --enable-win64 \
    --enable-archs=i386,x86_64 \
    --without-alsa \
    --without-capi \
    --with-coreaudio \
    --with-cups \
    --without-dbus \
    --without-fontconfig \
    --with-freetype \
    --with-gettext \
    --without-gettextpo \
    --without-gphoto \
    --with-gnutls \
    --without-gssapi \
    --without-gstreamer \
    --without-inotify \
    --without-krb5 \
    --with-mingw \
    --without-netapi \
    --with-opencl \
    --without-opengl \
    --without-oss \
    --with-pcap \
    --with-pthread \
    --without-pulse \
    --without-sane \
    --with-sdl \
    --without-udev \
    --with-unwind \
    --without-usb \
    --without-v4l2 \
    --with-vulkan \
    --without-x
popd

pushd "${BUILDROOT}"/winecx-${CROSS_OVER_VERSION}
make -j$(sysctl -n hw.ncpu 2>/dev/null)
popd

pushd "${BUILDROOT}"/winecx-${CROSS_OVER_VERSION}
make install-lib DESTDIR="${INSTALLROOT}/${WINE_INSTALLATION}"
popd
