# Ubuntu 22.04 (Jammy Jellyfish)をベースイメージとして使用
FROM ubuntu:22.04

# 環境変数を設定して、apt-get実行時の対話型プロンプトを抑制
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y sudo

# 新しいユーザー 'osuser' を作成
# --disabled-password: パスワードなしで作成
# --gecos "": フルネーム等の対話情報をスキップ
RUN adduser --disabled-password --gecos "" osuser \
    && adduser osuser sudo # 必要に応じてsudoグループに追加

# osuserがパスワードなしでsudoを実行できるよう設定ファイルを作成
RUN echo 'osuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/osuser

# 必要なパッケージをインストール
# ここにインストールしたいGUIアプリケーションを追加してください
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4-terminal \
    # その他必要なツール (例: git, curl, build-essentialなど)
    git \
    curl \
    build-essential \
    ansible\
    dosfstools\
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# DEBIAN_FRONTENDをリセット
ENV DEBIAN_FRONTEND=dialog
