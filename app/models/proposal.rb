class Proposal < ApplicationRecord
  belongs_to :pre_poll
  has_many :choiceitems, dependent: :destroy

  scope :default_order, -> { order(:id) }

  validates :user_name, presence: true
end