install-latest-openssh
======================

## はじめに

[rupor-github/wsl-ssh-agent: Helper to interface with Windows ssh-agent.exe service from Windows Subsystem for Linux (WSL)](https://github.com/rupor-github/wsl-ssh-agent)
を使って WSL (Windows Subsystem for Linux) から Windows 10 の ssh-agent を使うためのセットアップスクリプトです。

## 各スクリプトの内容

### install-latest-openssh.ps1: Windows用のOpenSSH最新版をセットアップ
#### スクリプトの説明

[PowerShell/Win32-OpenSSH: Win32 port of OpenSSH](https://github.com/PowerShell/Win32-OpenSSH) の [Releases](https://github.com/PowerShell/Win32-OpenSSH/releases) から最新版の OpenSSH の zip ファイルをダウンロード、展開し、sshd と ssh-agent のサービス登録と自動起動設定を行うスクリプトです。

2022年5月8日の時点では Windows 10 の標準の OpenSSH のバージョンは 8.1p1 です。

```
C:\>C:\Windows\System32\OpenSSH\ssh.exe -V
OpenSSH_for_Windows_8.1p1, LibreSSL 3.0.2
```

ですが、 WSL (Windows Subsystem for Linux) の Ubuntu-22.04 は 8.9p1 です。

```
$ ssh -V
OpenSSH_8.9p1 Ubuntu-3, OpenSSL 3.0.2 15 Mar 2022
```

WSL の Ubuntu-22.04 から Windows 標準の ssh-agent を使って ssh で他のサーバに接続しようとすると
ssh-agent で保持している鍵が提供されないという問題を「ssh -vvv 接続先ホスト」で確認しました。

そこで上記のレポジトリから最新版をダウンロード、インストールしてみたところ無事に動作しました。
そのセットアップを自動化するのがこのスクリプトです。

[Releases](https://github.com/PowerShell/Win32-OpenSSH/releases) で提供されているバージョンは V8.9.1.0p1-Beta のようにベータ版である点にご注意ください。
過去のバージョンを見ても全てベータとなっているので私は気にしないことにしました。
.msi のインストーラも提供されていて手動で実行するならこちらでも良いですが、PowerShell で自動化するには .zip ファイルのほうが便利なのでこちらを使っています。
.zip ファイルの展開先は .msi のインストーラと同じく C:\Program Files\OpenSSH としています。
（ちなみに Windows 標準の OpenSSH は C:\Windows\System32\OpenSSH にインストールされます）。

#### セットアップ実行手順

1. PowerShell を管理者権限で起動します（いくつか方法がありますが、例えば スタートメニューで右クリックしてポップアップメニューの[Windows PowerShell (管理者)]を選択）
2. 今回のプロセスに限定して PowerShell スクリプトの実行を許可します。

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
```

実行すると以下のようなメッセージが表示されますので、「Y」とEnterを押して許可します。

```
PS C:\Windows\system32> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

実行ポリシーの変更
実行ポリシーは、信頼されていないスクリプトからの保護に役立ちます。実行ポリシーを変更すると、about_Execution_Policies
のヘルプ トピック (https://go.microsoft.com/fwlink/?LinkID=135170)
で説明されているセキュリティ上の危険にさらされる可能性があります。実行ポリシーを変更しますか?
[Y] はい(Y)  [A] すべて続行(A)  [N] いいえ(N)  [L] すべて無視(L)  [S] 中断(S)  [?] ヘルプ (既定値は "N"): Y
```

3. install-latest-openssh.ps1 を実行します。私が使っている手順は、以下の通りです。
    1. エクスプローラで install-latest-openssh.ps1 を選択して SHIFT キーを押しながら右クリックして「パスのコピー」を選択
    2. 上記の PowerShell のプロンプトに「& 」と入力後、右クリックでペーストし、Enter を押して実行。

### install-wsl-ssh-agent.ps1: wsl-ssh-agentをセットアップ
### スクリプトの処理内容の説明

[rupor-github/wsl-ssh-agent: Helper to interface with Windows ssh-agent.exe service from Windows Subsystem for Linux (WSL)](https://github.com/rupor-github/wsl-ssh-agent) の [Releases](https://github.com/rupor-github/wsl-ssh-agent/releases) から最新版をダウンロード、C:\wsl-ssh-agent に展開します。

#### セットアップ実行手順

install-latest-openssh.ps1 の実行手順と同様にして install-wsl-ssh-agent.ps1 を実行します。

### wsl2-edit-bashrc.sh: WSL2のインスタンスでssh-agentを使う設定

### スクリプトの処理内容の説明

socat パッケージをインストールし、 ~/.bashrc に [WSL 2 compatibility](https://github.com/rupor-github/wsl-ssh-agent#wsl-2-compatibility) を少し変更したコードを追加します。
（ SSH_AUTH_SOCK の値を $HOME/.ssh/agent.sock から $HOME/.ssh/agent-$WSL_DISTRO_NAME.sock に変えています。例えば Ubuntu-22.04 と Ubuntu-20.04 のように WSL2 のインスタンスを複数起動していると ss -a で別インスタンスの出力も出てきたので、名前を重複しないように変更しています）。

#### セットアップ実行手順

設定したい WSL2 のインスタンスのシェルを開いて wsl2-edit-bashrc.sh を実行します。

例えば C:\Users\hnakamur\Downloads\my-WSL-setup-scripts-main\ssh-agent\wsl2-edit-bashrc.sh にある場合は以下のように実行します。

```
/mnt/c/Users/hnakamur/Downloads/my-WSL-setup-scripts-main/ssh-agent/wsl2-edit-bashrc.sh
```

シェルを一旦終了して再度起動するか `exec $SHELL -l` を実行すると ssh-agent が利用できるようになります。

### wsl1-create-shortcut.ps1: WSL1用にwsl-ssh-agentをスタートアップに登録
### スクリプトの処理内容の説明

[rupor-github/wsl-ssh-agent: Helper to interface with Windows ssh-agent.exe service from Windows Subsystem for Linux (WSL)](https://github.com/rupor-github/wsl-ssh-agent) を WSL1 のインスタンスで利用するには Windows 側で wsl-ssh-agent-gui.exe を実行しておく必要があります。

このスクリプトは wsl-ssh-agent-gui.exe へのショートカットをスタートアップディレクトリに作成して、Windows へのログオン時に自動実行されるようにします。
wsl-ssh-agent-gui.exe への引数で `-sock C:\wsl-ssh-agent\ssh-agent.sock` とソケットファイルのパスを指定しています。

#### セットアップ実行手順

wsl1-create-shortcut.ps1 の実行には管理者権限は不要です。

エクスプローラで wsl1-create-shortcut.ps1 を選択し、右クリックでポップアップメニューの「PowerShell で実行」を選択して実行します。

### wsl1-edit-profile.sh: WSL1用に ~/.profile に ssh-agent の設定を追加
### スクリプトの処理内容の説明

WSL1 の ~/.profile に環境変数 SSH_AUTH_SOCK の値を `/mnt/c/wsl-ssh-agent/ssh-agent.sock` に設定するコードを追加します。


#### セットアップ実行手順

設定したい WSL1 のインスタンスのシェルを開いて wsl1-edit-profile.sh を実行します。

例えば C:\Users\hnakamur\Downloads\my-WSL-setup-scripts-main\ssh-agent\wsl1-edit-profile.sh にある場合は以下のように実行します。

```
/mnt/c/Users/hnakamur/Downloads/my-WSL-setup-scripts-main/ssh-agent/wsl1-edit-profile.sh
```

シェルを一旦終了して再度起動するか `exec $SHELL -l` を実行すると ssh-agent が利用できるようになります。
