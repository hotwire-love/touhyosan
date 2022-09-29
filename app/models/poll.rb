class Poll < ApplicationRecord
  validates :title, presence: true
  has_many :choices, dependent: :destroy

  def choices_text
    choices.map(&:title).join("\n")
  end

  def choices_text=(text)
    self.choices = text.split("\n").map { |title| choices.find_or_initialize_by(title:) }
  end
end
