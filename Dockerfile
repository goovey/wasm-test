# Use a stable Ubuntu LTS as the base
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl cmake ninja-build \
    libglib2.0-0 nodejs libfontconfig1 libdbus-1-3 \
    libgl1-mesa-dev libxkbcommon-dev && \
    rm -rf /var/lib/apt/lists/*

# 2. Install aqtinstall
RUN pip3 install --break-system-packages aqtinstall

# 3. Install Qt Host Tools AND WebAssembly binaries
# We force the use of the official Qt archive to avoid XML/checksum errors on mirrors
RUN aqt install-qt linux desktop 6.8.0 linux_gcc_64 && \
    aqt install-qt all_os wasm 6.8.0 wasm_singlethread 

RUN chmod -R +x /6.8.0/wasm_singlethread/bin && \
    chmod -R +x /6.8.0/gcc_64/bin

# 4. Set up Emscripten (Pinned to the version Qt 6.8 expects)
ENV EMSDK_PATH=/opt/emsdk
RUN git clone https://github.com/emscripten-core/emsdk.git $EMSDK_PATH && \
    cd $EMSDK_PATH && \
    ./emsdk install 3.1.56 && \
    ./emsdk activate 3.1.56

# 5. Updated Environment Paths
# We add both the host bin and the wasm bin to the path
ENV PATH="/6.8.0/wasm_singlethread/bin:/6.8.0/gcc_64/bin:/opt/emsdk:/opt/emsdk/upstream/emscripten:${PATH}"

ENV EMSDK="/opt/emsdk"
ENV Qt6_DIR="/6.8.0/wasm_singlethread/lib/cmake/Qt6"
ENV QT_HOST_PATH="/6.8.0/gcc_64"

WORKDIR /project
