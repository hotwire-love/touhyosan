class Choice < ApplicationRecord
  belongs_to :poll
  has_many :vote_details, dependent: :destroy

  validates :title, presence: true

  scope :default_order, -> { order(:id) }
end
