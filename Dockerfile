# Node.js Android 编译 - Termux 构建环境
# 基于 Termux 构建系统的 Docker 镜像

FROM ubuntu:22.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TERMUX_VERSION=0.118.0
ENV NDK_VERSION=r27d
ENV ICU_VERSION=78.1

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    unzip \
    xz-utils \
    python3 \
    python3-pip \
    ninja-build \
    ccache \
    && rm -rf /var/lib/apt/lists/*

# 下载并安装 Android NDK
RUN wget -q https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux.zip -O /tmp/ndk.zip && \
    unzip -q /tmp/ndk.zip -d /opt/ && \
    rm /tmp/ndk.zip

# 设置 NDK 环境变量
ENV ANDROID_NDK_HOME=/opt/android-ndk-${NDK_VERSION}
ENV PATH="${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH}"

# 下载 Chromium Clang (用于 V8)
ENV LLVM_TAR=clang-llvmorg-21-init-5118-g52cd27e6-5.tar.xz
RUN cd /tmp && \
    wget -q https://commondatastorage.googleapis.com/chromium-browser-clang/Linux_x64/${LLVM_TAR} && \
    mkdir -p /opt/llvm-project-build && \
    tar --extract -f /tmp/${LLVM_TAR} --directory=/opt/llvm-project-build && \
    rm /tmp/${LLVM_TAR}

# 构建 ICU
ENV ICU_TAR=icu4c-${ICU_VERSION}-sources.tgz
RUN cd /tmp && \
    wget -q https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION}/${ICU_TAR} && \
    tar xf ${ICU_TAR} && \
    cd icu/source && \
    ./configure --prefix=/opt/icu-installed --disable-samples --disable-tests && \
    make -j$(nproc) install && \
    rm -rf /tmp/icu*

ENV LD_LIBRARY_PATH=/opt/icu-installed/lib:${LD_LIBRARY_PATH}
ENV CC_host=/opt/llvm-project-build/bin/clang
ENV CXX_host=/opt/llvm-project-build/bin/clang++

# 创建工作目录
WORKDIR /workspace

# 复制补丁文件
COPY patches/ /workspace/patches/

# 默认命令
CMD ["/bin/bash"]
