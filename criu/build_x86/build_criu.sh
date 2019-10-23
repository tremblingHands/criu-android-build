#!/bin/sh
#export NDK=$(pwd)/android-ndk
#export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64/
export NDK=/usr/x86_64-linux-android-4.9
export TOOLCHAIN=$NDK


export PATH=$TOOLCHAIN/bin:$PATH
export SYSROOT=$TOOLCHAIN/sysroot
#export CC="x86_64-linux-android28-clang --sysroot $SYSROOT"
#export CXX="x86_64-linux-android28-clang++ --sysroot $SYSROOT"
export CC="x86_64-linux-android-clang  --sysroot $SYSROOT"
export CXX="x86_64-linux-android-clang++ --sysroot $SYSROOT"
 
mkdir -p target
export PKG_CONFIG_PATH=$(pwd)/target/lib/pkgconfig

cd protobuf

./autogen.sh

./configure --prefix=$(pwd)/../target \
--host=x86_64-linux-android \
--with-sysroot=$SYSROOT \
--disable-shared \
--enable-cross-compile \
--with-protoc=protoc \
CFLAGS="-march=x86-64" \
CXXFLAGS="-march=x86-64 -frtti -fexceptions" \
LIBS="-llog -lz -lc++_static"
 
make -j $(nproc)&& make install

cd ..

cd protobuf-c 

./autogen.sh

CPPFLAGS=`pkg-config --cflags protobuf` LDFLAGS=`pkg-config --libs protobuf` \
	./configure --prefix=$(pwd)/../target \
	--disable-shared \
	--enable-static \
	--disable-protoc \
	--host=x86_64-linux-android

make -j $(nproc) && make install

cd ..

cd libnet

./autogen.sh

./configure --prefix=$(pwd)/../../target \
	--disable-shared \
	--enable-static \
	--host=x86_64-linux-android

make -C doc doc && make -j $(nproc)&& make dist && make install

cd ..

cd libnl

./autogen.sh

./configure --prefix=$(pwd)/../target \
	--disable-shared \
	--enable-static \
	--host=x86_64-linux-android \
	--disable-pthreads

make -j $(nproc) V=1 && make install

cd ..

cd missing

$CC -c aio.c
$CC -c fanotify.c
$CC -c pivot_root.c
$CC -c index.c
ar -rcs libmissing.a aio.o fanotify.o pivot_root.o index.o
cp libmissing.a $(pwd)/../target/lib/
mkdir -p $(pwd)/../target/include/sys/
cp aio.h $(pwd)/../target/include/
cp fanotify.h $(pwd)/../target/include/sys/
cd ..

cd criu

rm ./images/google/protobuf/descriptor.proto
cp ../target/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto


ARCH=x86 LD=ld CROSS_COMPILE=x86_64-linux-android-  CFLAGS="-Wno-macro-redefined $(pkg-config --cflags libprotobuf-c) -I $(pwd)/../target/include" LDFLAGS="-L $(pwd)/../target/lib -lmissing $(pkg-config --libs libnl-3.0) $(pkg-config --libs libprotobuf-c) " make  criu/criu
