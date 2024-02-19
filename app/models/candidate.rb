class Candidate < ApplicationRecord
  belongs_to :pre_poll
  has_many :choicecandidates, dependent: :destroy

  scope :default_order, -> { order(:id) }
end
