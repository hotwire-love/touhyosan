class Poll < ApplicationRecord
  validates :title, presence: true
  has_many :choices, dependent: :destroy
end
