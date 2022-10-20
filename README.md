# touhyosan

[Hotwire.love](https://hotwire-love.connpass.com/)のミートアップで「みんなが話したいテーマ」を多数決で決めるためのツールです。

## Design 

簡単なER図や画面遷移図など。

https://miro.com/app/board/uXjVPSNbiAc=/

## Requirements

- Ruby 3.x.x (Gemfileに記載されているRubyバージョンを参照)
- PostgreSQL
- yarn

## How to setup 

1. 自分のアカウントにリポジトリをフォークする
1. ローカル環境にgit cloneして`cd touhyosan`
1. DBの接続情報をローカル環境に合わせて更新する　
   - `cp config/database.yml.sample config/database.yml`
   - `vi config/database.yml`
1. `bin/setup`を実行する
1. `bin/dev`でサーバーを起動する
1. http://localhost:3000 が正常に表示されればOK

## License 

MIT License.
