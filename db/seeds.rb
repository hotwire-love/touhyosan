Vote.destroy_all
Choice.destroy_all
Poll.destroy_all
# TODO: VoteDetailを作ったら削除するコードを追加

poll = Poll.create!(title: 'Hotwire.love Vol.1のトークテーマ')
poll.choices.create!(title: 'jQueryからHotwireに移行するためのノウハウが知りたい')
poll.choices.create!(title: 'Hotwireが向いている/向いていないユースケースが知りたい')
poll.choices.create!(title: 'Hotwireとデザイナーがいい感じに協業する方法について')

poll.votes.create!(user_name: 'いとう', comment: '易しめのトピックだと嬉しい')
poll.votes.create!(user_name: 'いちろー', comment: '家の用事があるため19時で抜けます')
poll.votes.create!(user_name: 'ひーくん')

# TODO: VoteDetailを作ったら登録するコードを追加
