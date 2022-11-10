class VoteDetail < ApplicationRecord
  belongs_to :vote
  belongs_to :choice

  validates :status, presence: true
  validates :vote_id, uniqueness: { scope: :choice_id }

  enum :status, %i[yes yes_and_no no]

  scope :choice_order, -> { order(:choice_id) }
end
