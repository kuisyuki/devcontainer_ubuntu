# ベースイメージとしてUbuntu 24.10を使用
FROM ubuntu:24.10

USER root

# タイムゾーンを非対話的に設定
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# 必要なパッケージのインストール
RUN apt-get update && \
    apt-get install -y \
    jq sql-migrate apt-transport-https ca-certificates curl gnupg-agent software-properties-common sudo vim nano passwd zip unzip wget init systemd

# Dockerの公開鍵の追加とリポジトリの設定
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Docker関連のパッケージのインストール
RUN apt-get update && \
    apt-get install -y docker-ce docker-compose

# PHPと必要な拡張のインストール
RUN apt-get install -y \
    php php-cli php-fpm php-mbstring php-xml php-bcmath php-json php-mysql php-zip php-curl composer

# アスキーアートスクリプトの追加
COPY ../docker/motd.sh /etc/profile.d/motd.sh
RUN chmod +x /etc/profile.d/motd.sh

# ubuntuユーザーの設定
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo 'alias ll="ls -l"' >> /home/ubuntu/.bashrc

# ユーザーをdockerグループに追加
RUN usermod -aG docker ubuntu

# Voltaのインストール
USER ubuntu
RUN curl https://get.volta.sh | bash
ENV PATH="/home/ubuntu/.volta/bin:$PATH"

# NodeとYarnの最新バージョンをインストール
RUN volta install node@22.4.0 && \
    volta install yarn@4.3.1

# .bashrcにスクリプトをソースするように追加
RUN echo 'source /etc/profile.d/motd.sh' >> /home/ubuntu/.bashrc
