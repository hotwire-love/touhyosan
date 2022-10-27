class VoteDetail < ApplicationRecord
  belongs_to :vote
  belongs_to :choice

  enum :status, %i[yes yes_and_no no]
end
