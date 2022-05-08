enable_WSL_vEthernet_forwarding
===============================

WSL2 から Hyper-V の VM に ssh などをするために
`vEthernet (WSL)` の forwarding を有効にするスクリプトです。

一度有効にしても Windows Update か何かのタイミングで無効に戻ってしまう
という問題があるので、手軽に実行できるようスクリプト化しました。

## 使い方

### 現在の状態確認

エクスプローラーで `show_vEthernet_forwarding.cmd` をダブルクリックします。

出力例。
```
C:\Users\h-nakamura\enable_WSL_vEthernet_forwarding>powershell.exe -NoExit .\show_vEthernet_forwardning.ps1

InterfaceAlias             AddressFamily ConnectionState Forwarding
--------------             ------------- --------------- ----------
vEthernet (Default Switch)          IPv4       Connected   Disabled
vEthernet (Default Switch)          IPv6       Connected   Disabled
vEthernet (WinNAT)                  IPv4       Connected    Enabled
vEthernet (WinNAT)                  IPv6       Connected    Enabled
vEthernet (WinNAT2)                 IPv4       Connected    Enabled
vEthernet (WinNAT2)                 IPv6       Connected    Enabled
vEthernet (WSL)                     IPv4       Connected    Enabled
vEthernet (WSL)                     IPv6       Connected    Enabled
```

### `vEthernet (WSL)` の Forwarding を有効にする

エクスプローラーで `enable_WSL_vEthernet_forwarding.cmd` をダブルクリックします。
すると以下のようなダイアログが表示されますので「はい」を押します。　

```
ユーザーアカウント制御
このアプリがデバイスに変更を加えることを許可しますか？
Windows PowerShell

[はい]  [いいえ]
```

するとこのスクリプトは forwarding を有効にした後、変更後の状態を出力します。

### `vEthernet (WSL)` の Forwarding を無効にする

エクスプローラーで `disable_WSL_vEthernet_forwarding.cmd` をダブルクリックします。前項と同様に「ユーザーアカウント制御」のダイアログで「はい」を押します。

## 参考資料
* forwardingを有効にするコマンドと戻ってしまう問題については [After converting to WSL2 no longer able to route traffic to other VSwitches on the same host. ・ Issue #4288 ・ microsoft/WSL](https://github.com/microsoft/WSL/issues/4288) を参考にしました。
* カレントディレクトリを引き継ぎつつ管理者権限でPowerShellを起動してスクリプトを実行するのは [working directory - How do I run a PowerShell script as administrator using a shortcut? - Stack Overflow](https://stackoverflow.com/questions/66362383/how-do-i-run-a-powershell-script-as-administrator-using-a-shortcut) を参考にしました。
* `#Requires -RunAsAdministrator` について [How to Run PowerShell Script as Administrator? – TheITBros](https://theitbros.com/run-powershell-script-as-administrator/)
