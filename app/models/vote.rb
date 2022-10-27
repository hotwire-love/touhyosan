class Vote < ApplicationRecord
  belongs_to :poll
  has_many :vote_details, dependent: :destroy

  validates :user_name, presence: true
end
