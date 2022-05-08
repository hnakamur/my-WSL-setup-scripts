show-distribution-in-prompt
===========================

WSL で複数のディストリビューションを使っているとシェルでどのディストリビューションか分かるようにしたいと思ったので
~/.bashrc のプロンプト設定を変更するスクリプトを書きました。

## edit-bashrc-prompt.sh: ~/.bashrc のプロンプト設定を変更
### スクリプトの処理内容の説明

PS1 を設定している3箇所でホスト名 `@\h` の前に `@$WSL_DISTRO_NAME` を追加します。

## 実行方法

設定した WSL のインスタンスのシェルを開いて edit-bashrc-prompt.sh を実行します。


例えば C:\Users\hnakamur\Downloads\my-WSL-setup-scripts-main\show-distribution-in-prompt\edit-bashrc-prompt.sh にある場合は以下のように実行します。

```
/mnt/c/Users/hnakamur/Downloads/my-WSL-setup-scripts-main/show-distribution-in-prompt/edit-bashrc-prompt.sh
```

シェルを一旦終了して再度起動するか `exec $SHELL -l` を実行するとプロンプトが変更されます。
