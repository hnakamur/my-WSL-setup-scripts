share-files-between-WSL2-distributions
======================================

WSL で複数のインスタンスを使っていると、インスタンス間でファイルをコピーしたいと思ったので調べてみると
https://stackoverflow.com/a/65838203/1391518 で各インスタンスの / を bind mount する方法が紹介されていました。

これを `~/.profile` に追加するスクリプトです。

## edit-profile-for-bind-mount.sh: ~/.profile に bind mount の設定を追記
### スクリプトの処理内容の説明

ログイン時に / を `/mnt/wsl/$WSL_DISTRO_NAME` に bind mount するように `~/.profile` に追記します。

## 実行方法

設定した WSL のインスタンスのシェルを開いて edit-profile-for-bind-mount.sh を実行します。


例えば C:\Users\hnakamur\Downloads\my-WSL-setup-scripts-main\share-files-between-WSL2-distributions\edit-profile-for-bind-mount.sh にある場合は以下のように実行します。

```
/mnt/c/Users/hnakamur/Downloads/my-WSL-setup-scripts-main/share-files-between-WSL2-distributions/edit-profile-for-bind-mount.sh
```

シェルを一旦終了して再度起動するか `exec $SHELL -l` を実行するとプロンプトが変更されます。
