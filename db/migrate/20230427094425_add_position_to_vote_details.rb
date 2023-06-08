class AddPositionToVoteDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :vote_details, :position, :integer
  end
end
