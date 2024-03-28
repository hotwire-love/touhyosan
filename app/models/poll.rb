class Poll < ApplicationRecord
  has_many :choices, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :title, presence: true
end
