# touhyosan

[Hotwire.love](https://hotwire-love.connpass.com/)のミートアップで「みんなが話したいテーマ」を多数決で決めるためのツールです。

https://touhyosan.hotwire.love/

## Design 

簡単なER図や画面遷移図など。

https://miro.com/app/board/uXjVPSNbiAc=/

## Requirements

- Ruby 3.x.x (Gemfileに記載されているRubyバージョンを参照)
- PostgreSQLを推奨、sqlite3でも可
- yarn

## How to setup 

1. 自分のアカウントにリポジトリをフォークする
1. ローカル環境にgit cloneして`cd touhyosan`
1. DBの接続情報をローカル環境に合わせて更新する　
   - PostgreSQLを使う場合（推奨） `cp config/database.yml.postgres.example config/database.yml`
   - SQLite3を使う場合 `cp config/database.yml.sqlite3.example config/database.yml`
   - `vi config/database.yml`
   - `database.yml.example` にはPostgreSQLの設定例と、sqlite3の設定例が載っています
1. `bin/setup`を実行する
   - sqlite3環境の場合、`schema.rb`に多少diffが発生しますが、いったん無視してもらって大丈夫です
1. `bin/dev`でサーバーを起動する
1. http://localhost:3000 が正常に表示されればOK

## How to setup in docker
1. PostgreSQL(version 14)、Redis(version 7.0)をコンテナとして用いる。
1. "How to setup" のうち、DBの接続情報の部分を以下のように置き換えます。
   - PostgreSQL用DBの接続情報をを用意 `cp config/database.yml.postgres.example config/database.yml`
   - config/database.ymlのdefault部分に以下を追加
     - host: localhost
     - username: postgres
     - password: passw@rd
   - `docker compose up -d` (docker compose V2の場合)
   - `docker-compose up -d` (docker compose V1の場合。ただしV1は2023年6月末ににサポート終了)
   - コンテナを終了させたい場合は以下のようにコマンドを実行します。
     - `docker compose down` (docker compose V2の場合)
     - `docker-compose down` (docker compose V1の場合)


## How to deploy

運営メンバーがmainブランチを更新すると自動的にHerokuにデプロイされます。（運営メンバーは事前にGitHubアカウントをHerokuと連携させておくこと）

## License 

MIT License.
