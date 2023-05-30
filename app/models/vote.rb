class Vote < ApplicationRecord
  belongs_to :poll
  has_many :vote_details, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :vote_details

  # TODO: ランダムなデフォルト名にしたい
  attribute :user_name, :string, default: 'ななしさん'

  validates :user_name, presence: true

  scope :default_order, -> { order(:id) }
end
