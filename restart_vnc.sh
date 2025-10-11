#!/usr/bin/env bash

#
# desktop-lite (VNC/noVNC) 再起動用スクリプト
#

set -e

echo "VNCサービスの再起動を開始します..."

# root権限でない場合はエラー
if [ "$(id -u)" -ne 0 ]; then
  echo "エラー: このスクリプトはroot権限で実行する必要があります。 'sudo ./restart-vnc.sh' のように実行してください。" >&2
  exit 1
fi

# --- 1. 既存サービスの停止 ---
echo "[1/3] 既存のVNCおよびnoVNCサービスを停止しています..."

# VNCサーバーを停止 (desktop-init.sh のデフォルトDISPLAYである :1 を指定)
# サーバーが起動していない場合もエラーにしない
tigervncserver -kill :1 || echo "VNCサーバーは既に停止していました。"

# noVNCのプロキシプロセスを停止
# プロセスが存在しない場合もエラーにしない
pkill -f "novnc_proxy" || echo "noVNCプロキシ(novnc_proxy)は実行されていませんでした。"
pkill -f "launch.sh" || echo "noVNCプロキシ(launch.sh)は実行されていませんでした。"

# 念のため、関連プロセスが残っていれば強制終了
pkill Xtigervnc || true
sleep 2 # プロセスが完全に終了するのを待つ

echo "サービスの停止が完了しました。"

# --- 2. 一時ファイルのクリーンアップ ---
echo "[2/3] 一時ファイルをクリーンアップしています..."
rm -rf /tmp/.X11-unix /tmp/.X*-lock
echo "クリーンアップが完了しました。"

# --- 3. サービスの再起動 ---
echo "[3/3] サービスを再起動しています..."

# 元の初期化スクリプトを実行してサービスを開始する
# バックグラウンドで実行し、ログは破棄する
/usr/local/share/desktop-init.sh > /dev/null 2>&1 &
sleep 3 # サービスが起動するのを少し待つ

# --- 完了確認 ---
if pgrep -x "Xtigervnc" > /dev/null; then
    echo "✅ 成功: VNCサーバーが正常に再起動されました。"
else
    echo "❌ 失敗: VNCサーバーの再起動に失敗しました。/tmp/container-init.log を確認してください。"
    exit 1
fi
