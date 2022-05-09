実装メモ
=======

# PowerShell の実行ポリシー (ExecutionPolicy)

1次情報: [about Execution Policies - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1)

* セキュリティ上デフォルトは Restricted になっていてスクリプトファイルは実行できない。
* インストール時のみ管理者権限でスクリプトファイルを実行したいときは、管理者権限で PowerShell を開いて `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted` でそのプロセス内のみで許可するという手がある。
* [15 Ways to Bypass the PowerShell Execution Policy](https://www.netspi.com/blog/technical/network-penetration-testing/15-ways-to-bypass-the-powershell-execution-policy/) に ExecutionPolicy が Unrestricted の状態でも PowerShell でスクリプト片を実行する回避策が紹介されていた（マルウェアでも使われそうなので注意が必要）。このレポジトリ内のスクリプトでは以下の2つの手法を使っています。
    * powershell.exe の `-Command` オプションで実行したいコマンドを指定する。コマンドが短い場合はこれがお手軽です。
    * コマンド列を標準出力に出力し、 `| powershell.exe -` のようにパイプでつないで PowerShell の標準入力に流し込んで実行する。コマンド列が長い場合はこちらが便利です。
    
# バッチファイル内で PowerShell のコマンド列を出力する際の特殊文字のエスケープ

上記のコマンド列を標準出力する箇所はバッチファイルを使います。
ここで文字のエスケープが重要になります。
1次情報は見つけられなかったのですが [Batch files - Escape Characters](https://www.robvanderwoude.com/escapechars.php) などにまとまっています。

例として `register_schedule_task.cmd` を引用します。

```
@echo off
echo $folderName = '\MyTasks';^
$taskName = 'Enable WSL vEthernet forwarding';^
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent();^
$principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser);^
if (-not($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))) {^
  Write-Output 'This script must be run as administrator.';^
  Start-Sleep -Seconds 1;^
  exit;^
}^
if ((Get-ScheduledTaskInfo -TaskName "$folderName\$taskName" -ErrorAction SilentlyContinue) -eq $null) {^
    $action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/c wsl.exe echo start default WSL instance and enable forwardning of vEthernet \(WSL\) && powershell.exe -Command ""Set-NetIPInterface -InterfaceAlias 'vEthernet (WSL)' -Forwarding Enabled""";^
    $trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser.Name;^
    $principal = New-ScheduledTaskPrincipal $currentUser.Name -RunLevel Highest;^
    Register-ScheduledTask -TaskName $taskName -TaskPath $folderName -Action $action -Principal $principal -Trigger $trigger;^
} | powershell.exe -
```

PowerShell のコマンド列を1行に出力するのですが、 PowerShell の複数のコマンドの区切りに `;` を入れて、改行文字をバッチでエスケープするために `^` を行末に入れています。

# PowerShell の文字列内での特殊文字のエスケープ

1次情報: [about Quoting Rules - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.2)

* 文字列内で `$変数名` の変数展開をしたい場合は全体をシングルクォートではなくダブルクォートで囲む必要がある。
* ダブルクォートで囲んだ文字列内でダブルクォートを含めたい場合は2連のダブルクォート `""` を書く。

上記の例の `New-ScheduledTaskAction` の `-Argument` の値の中で2連のダブルクォートを使用しています。
