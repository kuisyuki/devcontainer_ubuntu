# ベースイメージとしてUbuntu 24.10を使用
FROM ubuntu:24.10

USER root

# タイムゾーンを非対話的に設定
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# 必要最低限のパッケージのインストール
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
    sudo vim nano passwd zip unzip wget git \
    build-essential python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Dockerの公開鍵の追加とリポジトリの設定
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Docker関連のパッケージのインストール
RUN apt-get update && \
    apt-get install -y docker-ce docker-compose && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# アスキーアートスクリプトの追加
COPY ../docker/motd.sh /etc/profile.d/motd.sh
RUN chmod +x /etc/profile.d/motd.sh

# ubuntuユーザーの作成と設定
RUN useradd -m -s /bin/bash -u 1000 ubuntu || true && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo 'alias ll="ls -l"' >> /home/ubuntu/.bashrc

# ユーザーをdockerグループに追加
RUN usermod -aG docker ubuntu

# ユーザーを ubuntu に切り替える
USER ubuntu
