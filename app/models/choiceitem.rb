class Choiceitem < ApplicationRecord
  belongs_to :proposal

  validates :title, presence: true
  validates :accepted, inclusion: { in: [true, false] }

  scope :default_order, -> { order(:id) }
end
