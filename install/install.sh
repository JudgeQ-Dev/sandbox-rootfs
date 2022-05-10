#! /bin/bash

set -e

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Fix PATH environment variable
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

export DEBIAN_FRONTEND=noninteractive
export TERM=xterm-256color

# Set Locale
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
export LC_ALL=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' >/etc/default/locale

# Create sandbox user and directories
useradd -r sandbox -d /sandbox -m
mkdir -p /sandbox/{binary,source,working}

# Add focal-updates source
ORIGINAL_SOURCE=$(head -n 1 /etc/apt/sources.list)
# shellcheck disable=SC2001
sed 's/focal/focal-updates/' <<<"$ORIGINAL_SOURCE" >>/etc/apt/sources.list

# Install dependencies
apt-get update
apt-get dist-upgrade -y
apt-get install -y \
    gnupg \
    ca-certificates \
    curl \
    wget \
    locales \
    unzip \
    zip \
    git \
    lsb-release \
    software-properties-common

export GCC_VERSION=11
bash "${TOP_DIR}"/install_gcc.sh

export LLVM_VERSION=14
bash "${TOP_DIR}"/install_llvm.sh

# Key: Python repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BA6932366A755776
# Key: Go repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F6BC817356A3D45E
# Key: Haskell repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys FF3AEACEF6F88286
# Key: Mono repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main" >/etc/apt/sources.list.d/python.list
echo "deb http://ppa.launchpad.net/longsleep/golang-backports/ubuntu focal main" >/etc/apt/sources.list.d/go.list
echo "deb http://ppa.launchpad.net/hvr/ghc/ubuntu focal main" >/etc/apt/sources.list.d/haskell.list
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" >/etc/apt/sources.list.d/mono.list

# Install some language support via APT
apt-get update
apt-get install -y \
    gdb \
    openjdk-11-jdk \
    fpc \
    python2.7 \
    python3.6 \
    python3.9 \
    golang-go \
    ghc \
    mono-devel \
    fsharp

# Install Rust via Rustup
su sandbox -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"

# Install Kotlin via SDKMAN!
su sandbox -c "curl -s https://get.sdkman.io | bash"
su sandbox -s /bin/bash -c "source ~/.sdkman/bin/sdkman-init.sh && sdk install kotlin"

# Install Swift
SWIFT_URL_QUOTED="$(curl https://www.swift.org/download/ --compressed | grep -P '"([^"]+ubuntu20.04.tar.gz)"' -o | head -n 1)"
SWIFT_URL="$(eval "echo $SWIFT_URL_QUOTED")"
wget -O - "$SWIFT_URL" | tar -xzf - -C /opt
mv /opt/swift* /opt/swift

# Create symlinks for compilers and interpreters with non-common names and locations
ln -s /usr/bin/g++-10 /usr/local/bin/g++
ln -s /usr/bin/gcc-10 /usr/local/bin/gcc
ln -s /sandbox/.sdkman/candidates/kotlin/current/bin/kotlin /usr/local/bin/kotlin
ln -s /sandbox/.sdkman/candidates/kotlin/current/bin/kotlinc /usr/local/bin/kotlinc
ln -s /sandbox/.cargo/bin/rustc /usr/local/bin/rustc
ln -s /opt/swift/usr/bin/swiftc /usr/local/bin/swiftc

# Clean the APT cache
apt-get clean

# Install testlib
git clone https://github.com/MikeMirzayanov/testlib /tmp/testlib
cp /tmp/testlib/testlib.h /usr/include/
