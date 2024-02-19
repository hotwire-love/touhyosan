class PrePoll < ApplicationRecord
  has_many :proposals, dependent: :destroy
  has_many :candidates, dependent: :destroy

  # accepts_nested_attributes_for :proposals, allow_destroy: true

  validates :title, presence: true
  validates :editor_id, presence: true

  # The `after_create_commit` callback in the Ruby on Rails model is used to execute a block of code
  # after a record is created and committed to the database. In this case, the code is broadcasting
  # updates to specific channels using Action Cable.
  # The `after_create_commit` callback in the Ruby on Rails model is used to execute a block of code
  # after the record has been created and committed to the database. In this case, the code is
  # broadcasting updates to specific channels using ActionCable, which is Rails' integrated WebSocket
  # framework for real-time communication.
  after_create_commit ->(pre_poll) {
                        broadcast_update_to "editor", target: "editor_form", partial: "pre_polls/form", locals: { pre_poll: pre_poll }
                        broadcast_replace_to "proposer", target: "pre_poll_result", partial: "pre_polls/proposals/result", locals: { pre_poll: pre_poll }
                      }
end
