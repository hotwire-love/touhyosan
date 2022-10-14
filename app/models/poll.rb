class Poll < ApplicationRecord
  has_many :choices, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :title, presence: true

  def choices_text
    choices.map(&:title).join("\n")
  end

  def choices_text=(text)
    self.choices = text.split(/\R/).map { |title| choices.find_or_initialize_by(title:) }
  end
end
