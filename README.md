my-WSL-setup-scripts
====================

私の WSL (Windows Subsystem for Linux) 環境セットアップスクリプトです。
レポジトリの Code ボタンのドロップダウンから Download ZIP を押してダウンロードし、エクスプローラで展開して使うことを想定しています（もちろん他の方法で取得してもOKです）。

1. ダウンロードフォルダー (例: C:\Users\hnakamur\Downloads) にダウンロード
2. エクスプローラで選択して右クリックのポップアップメニューで[すべて展開...]を選択
3. 「ファイルを下のフォルダーに展開する」はダウンロードフォルダー  (例: C:\Users\hnakamur\Downloads) に変更
4. 「展開」ボタンを押して展開を実行

上記の操作でダウンロードフォルダーの下に my-WSL-setup-scripts-main というフォルダー (例: C:\Users\hnakamur\Downloads\my-WSL-setup-scripts-main) が作られます。

サブフォルダの説明

* ssh-agent: Windows の ssh-agent を WSL2 または WSL1 のインスタンスから使うための設定を行うスクリプト
* enable_WSL_vEthernet_forwarding: Windowsへのログオン時に「vEthernet (WSL)」のforwardingを有効にするスクリプト
* show-distribution-in-prompt: WSL2 または WSL1 のシェルのプロンプトにディストリビューション名を含めるスクリプト
* share-files-between-WSL2-distributions: WSL2 の複数のインスタンス間でファイルをコピーできるようにログイン時に bind mount するスクリプト
