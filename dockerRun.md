
## arm kernel

docker run --privileged -v /root/zxh/criu/criu-android-build/kernel:/root  -it jokenzhang/public:debian bash

apt install -y bc
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-eabi-
export PATH=/root/arm-prebuilt/bin:$PATH

cd /root
cp criu_arm_defconfig goldfish/arch/arm/configs/
cd goldfish
make clean
make ARCH=arm  criu_arm_defconfig
make ARCH=arm SUBARCH=arm  CROSS_COMPILE=arm-eabi-

## x86 android

repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-8.0.0_r16

apt-get install -y openjdk-8-jdk

apt-get install -y  git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-mul tilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip

apt-get install -y libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev g++-multilib 
apt-get install -y git flex bison gperf build-essential libncurses5-dev:i386 
apt-get install -y tofrodos python-markdown libxml2-utils xsltproc zlib1g-dev:i386 
apt-get install -y dpkg-dev libsdl1.2-dev libesd0-dev
apt-get install -y git-core gnupg flex bison gperf build-essential  
apt-get install -y zip curl zlib1g-dev gcc-multilib g++-multilib 
apt-get install -y libc6-dev-i386 
apt-get install -y lib32ncurses5-dev x11proto-core-dev libx11-dev 
apt-get install -y libgl1-mesa-dev libxml2-utils xsltproc unzip m4
apt-get install -y lib32z-dev ccache

export USER=$(whoami)
./prebuilts/sdk/tools/jack-admin start-server
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server


### kernel

make ARCH=x86  x86_64_ranchu_defconfig
make menuconfig
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-android-


## x86 runc

### NDK

//$NDK/build/tools/make-standalone-toolchain.sh --install-dir=/usr/x86_64-linux-android-4.9  --arch=x86_64 --platform=android-24
export PATH=$PATH:/usr/x86_64-linux-android-4.9/bin


$NDK/build/tools/make-standalone-toolchain.sh --install-dir=/usr/x86_64-linux-android-4.9  --arch=x86_64 --platform=android-26
export PATH=$PATH:/usr/x86_64-linux-android-4.9/bin


### runc

CC=x86_64-linux-android-gcc  CXX=x86_64-linux-android-g++  GOOS=android GOARCH=amd64 CGO_ENABLED=1  go build   -o /build/runc-x86_64 .

## x86 criu

docker run --privileged -v ~/zxh/criu/criu-android-build/criu/build_x86:/build -it criu-android bash
apt install zip


wget https://github.com/google/protobuf/archive/v3.1.0.tar.gz
mkdir protobuf
tar --strip=1 -xzvf protobuf.v3.1.0.tar.gz -C protobuf  1>/dev/null

wget https://github.com/protobuf-c/protobuf-c/archive/v1.3.0.tar.gz
mkdir protobuf-c
tar --strip=1 -xzvf protobuf-c.v1.3.0.tar.gz -C protobuf-c  1>/dev/null

wget https://github.com/libnet/libnet/releases/download/v1.2/libnet-1.2.tar.gz
mkdir libnet
tar --strip=1 -xzvf libnet-1.2.tar.gz -C libnet 1>/dev/null

//wget https://github.com/thom311/libnl/archive/libnl3_5_0.tar.gz
wget https://www.infradead.org/~tgr/libnl/files/libnl-3.2.25.tar.gz
mkdir libnl
tar --strip=1 -xzvf libnl-3.2.25.tar.gz -C libnl 1>/dev/null

wget tar --strip=1 -xzvf libnl-3.5.0.tar.gz -C libnl 1>/dev/null
mkdir criu
tar --strip=1 -xzvf v3.13.tar.gz -C criu 1>/dev/null

