enable_WSL_vEthernet_forwarding
===============================

WSL2 から Hyper-V の VM に ssh などをするために `vEthernet (WSL)` の forwarding を有効にするスクリプトです。


[WSL2 , problem with network connection when VPN used (PulseSecure) · Issue #5068 · microsoft/WSL](https://github.com/microsoft/WSL/issues/5068)
の [コメント](https://github.com/microsoft/WSL/issues/5068#issuecomment-988877403) の PowerShell のコードで forwarding を有効にできたのですが、
[別のコメント](https://github.com/microsoft/WSL/issues/5068#issuecomment-1087206431) にあるように VPN 切断時や Windows リブートの度に無効に戻ってしまいます。

そこで、ログオン時に `vEthernet (WSL)` の forwarding を有効にするスケジュールタスクを登録するスクリプトを書きました。

以下、各スクリプトの説明です。

## register_schedule_task.cmd: ログオン時のスケジュールタスク登録
### スクリプトの処理内容の説明

タスクスケジューラのタスクスケジュールライブラリに `\MyTasks` というフォルダを作成し、その下に「Enable WSL vEthernet forwarding」という名前のタスクを登録します。
登録するタスクのトリガーは設定したユーザのログオン時で、セキュリティオプションの「最上位の特権で実行する」を有効にしています。

## 実行方法

1. エクスプローラで register_schedule_task.cmd を選択
2. 右クリックでポップアップメニューを開き「管理者として実行」を選択
3. (初回のみ)「WindowsによってPCが保護されました」のダイアログが出たら「詳細情報」のリンクを押し「実行」ボタンを押して実行
4. 以下のような「ユーザーアカウント制御」のダイアログ表示されたら「はい」を押して実行。

```
ユーザーアカウント制御
このアプリがデバイスに変更を加えることを許可しますか？
Windows コマンドプロセッサ

[はい]  [いいえ]
```

## show_vEthernet_forwarding.cmd: vEthernetのfowardingの現在状態確認
### スクリプトの処理内容の説明

PowerShell を起動して Get-NetIPInterface で情報を取得し、 vEthernet に限定して整形して表示し、1秒後に閉じます。

## 実行方法

エクスプローラで `show_vEthernet_forwarding.cmd` をダブルクリックして実行します。
初回のみ「WindowsによってPCが保護されました」のダイアログが出ますので「詳細情報」のリンクを押し「実行」ボタンを押して実行します。


出力例。
```
InterfaceAlias             AddressFamily ConnectionState Forwarding
--------------             ------------- --------------- ----------
vEthernet (Default Switch)          IPv4       Connected   Disabled
vEthernet (Default Switch)          IPv6       Connected   Disabled
vEthernet (WSL)                     IPv4       Connected    Enabled
vEthernet (WSL)                     IPv6       Connected    Enabled
```
