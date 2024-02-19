class Choicecandidate < ApplicationRecord
  belongs_to :candidate
  validates :title, presence: true

  scope :default_order, -> { order(:id) }
end
