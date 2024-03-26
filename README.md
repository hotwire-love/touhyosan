# touhyosan

[Hotwire.love](https://hotwire-love.connpass.com/)のミートアップで「みんなが話したいテーマ」を多数決で決めるためのツールです。

https://touhyosan.hotwire.love/

## Design

簡単な ER 図や画面遷移図など。

https://miro.com/app/board/uXjVPSNbiAc=/

## Requirements

- Ruby 3.x.x (Gemfile に記載されている Ruby バージョンを参照)
- PostgreSQL を推奨、sqlite3 でも可
- yarn

## How to setup

1. 自分のアカウントにリポジトリをフォークする
1. ローカル環境に git clone して`cd touhyosan`
1. DB の接続情報をローカル環境に合わせて更新する
   - PostgreSQL を使う場合（推奨） `cp config/database.yml.postgres.example config/database.yml`
   - SQLite3 を使う場合 `cp config/database.yml.sqlite3.example config/database.yml`
   - `vi config/database.yml`
   - `database.yml.example` には PostgreSQL の設定例と、sqlite3 の設定例が載っています
1. `bin/setup`を実行する
   - sqlite3 環境の場合、`schema.rb`に多少 diff が発生しますが、いったん無視してもらって大丈夫です
1. `bin/dev`でサーバーを起動する
1. http://localhost:3000 が正常に表示されれば OK
1. 「Choices text」を入力せずに「登録する」ボタンを押すと、pre_poll が作成され、リダイレクトされます。
1. リダイレクト先 URL にアクセスすると、複数の人が選択肢を登録できます。テキストエリアに 1 行に一つの選択肢をテキストエリアに 1 行につき 1 個の選択肢を記述し、「更新」ボタンを推すと、サーバ上の pre_poll の選択肢が更新され、さらにこの URL にアクセスしている全てのブラヌザのテキストエリアも更新されます。
1. ただし、「更新」ボタンを押す際に排他制御は行っていないため、なんらかの手段で連絡を取りつつ、更新は必ず一人ずつ行うようにしてください。
1. 「生成」ボタンを押すと、テキストエリアに記述された選択肢をもつ poll が作成され、この URL にアクセスしている全てのブラウザが生成された poll の URL にリダイレクトされます。

## How to deploy

運営メンバーが main ブランチを更新すると自動的に Heroku にデプロイされます。（運営メンバーは事前に GitHub アカウントを Heroku と連携させておくこと）

## License

MIT License.
