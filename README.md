# MySQL Enterprise Encryptionを使用したハイブリッド鍵暗号化メソッドのチュートリアル

!!!
注: 本リポジトリ内のSQLはPoCを目的とした用途での利用を想定しています。
    これらのSQLを使って発生したいかなる損害についても作成者が責任を負うことはなく、
    また、質問についても対応することはありません。
!!!

## Requirements

- MySQL Server 8.4 Enterprise Edition
- MySQL Enterprise Encryption (https://dev.mysql.com/doc/refman/8.4/en/enterprise-encryption-installation.html)

## HOWTO

| sql              | 説明
|------------------|----------------------------------------
| 01_setup.sql     | チュートリアルに必要となるユーザやテーブルを作成します
| 02_encrypt.sql   | ハイブリッド鍵暗号化メソッドによる暗号化を実行し、結果を表示します
| 03_decrypt.sql   | ハイブリッド鍵暗号化メソッドによる復号化を実行し、結果を表示します
| 04_keyrotate.sql | マスターキーローテーションを実行します
| 05_cleanup.sql   | 01_setup.sqlによって作成されたオブジェクトを削除します

各SQLを表示しながら実行するとより理解が深まります

```
# mysql -vvv --show-warnings < 01_setup.sql
```

