class Vote < ApplicationRecord
  belongs_to :poll
  has_many :vote_details, dependent: :destroy
  accepts_nested_attributes_for :vote_details

  validates :user_name, presence: true
end
