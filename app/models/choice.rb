class Choice < ApplicationRecord
  belongs_to :poll
  has_many :vote_details, dependent: :destroy

  validates :title, presence: true

  scope :default_order, -> { order(:id) }

  after_create :append_vote_details

  def score
    vote_details.sum do |vd|
      vd.position || 100 # TODO: nullが入っている場合もあるので
    end
  end

  private

  def append_vote_details
    poll.votes.each do |vote|
      vote.vote_details.create!(choice: self, position: poll.choices.size - 1)
    end
  end
end
