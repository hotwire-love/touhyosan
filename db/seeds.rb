Vote.destroy_all
Choice.destroy_all
Poll.destroy_all
# TODO: VoteDetailを作ったら削除するコードを追加
VoteDetail.destroy_all

poll = Poll.create!(title: 'Hotwire.love Vol.1のトークテーマ')
poll.choices.create!(title: 'jQueryからHotwireに移行するためのノウハウが知りたい')
poll.choices.create!(title: 'Hotwireが向いている/向いていないユースケースが知りたい')
poll.choices.create!(title: 'Hotwireとデザイナーがいい感じに協業する方法について')

poll.votes.create!(user_name: 'いとう', comment: '易しめのトピックだと嬉しい')
poll.votes.create!(user_name: 'いちろー', comment: '家の用事があるため19時で抜けます')
poll.votes.create!(user_name: 'ひーくん')

# TODO: VoteDetailを作ったら登録するコードを追加
# status:0 "yes", 1:"yes_and_no", 2:"no"

poll.votes[0].vote_details.create(choice: poll.choices[0], status: 0)
poll.votes[0].vote_details.create(choice: poll.choices[1], status: 1)
poll.votes[0].vote_details.create(choice: poll.choices[2], status: 2)

poll.votes[1].vote_details.create(choice: poll.choices[0], status: 1)
poll.votes[1].vote_details.create(choice: poll.choices[1], status: 1)
poll.votes[1].vote_details.create(choice: poll.choices[2], status: 0)

poll.votes[2].vote_details.create(choice: poll.choices[0], status: 0)
poll.votes[2].vote_details.create(choice: poll.choices[1], status: 2)
poll.votes[2].vote_details.create(choice: poll.choices[2], status: 1)