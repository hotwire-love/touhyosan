class Vote < ApplicationRecord
  belongs_to :poll

  validates :user_name, presence: true
end
