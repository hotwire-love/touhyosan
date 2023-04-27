Vote.destroy_all
Choice.destroy_all
Poll.destroy_all
# TODO: VoteDetailを作ったら削除するコードを追加
VoteDetail.destroy_all

poll = Poll.create!(title: 'Hotwire.love Vol.1のトークテーマ')
choice_1 = poll.choices.create!(title: 'jQueryからHotwireに移行するためのノウハウが知りたい')
choice_2 = poll.choices.create!(title: 'Hotwireが向いている/向いていないユースケースが知りたい')
choice_3 = poll.choices.create!(title: 'Hotwireとデザイナーがいい感じに協業する方法について')


# TODO: VoteDetailを作ったら登録するコードを追加
# status:0 "yes", 1:"yes_and_no", 2:"no"

vote = poll.votes.create!(user_name: 'いとう', comment: '易しめのトピックだと嬉しい')
vote.vote_details.create(choice: choice_1, status: :yes)
vote.vote_details.create(choice: choice_2, status: :yes_and_no)
vote.vote_details.create(choice: choice_3, status: :no)

vote = poll.votes.create!(user_name: 'いちろー', comment: '家の用事があるため19時で抜けます')
vote.vote_details.create(choice: choice_1, status: :yes)
vote.vote_details.create(choice: choice_2, status: :yes_and_no)
vote.vote_details.create(choice: choice_3, status: :no)

vote = poll.votes.create!(user_name: 'ひーくん')
vote.vote_details.create(choice: choice_1, status: :yes)
vote.vote_details.create(choice: choice_2, status: :yes_and_no)
vote.vote_details.create(choice: choice_3, status: :no)