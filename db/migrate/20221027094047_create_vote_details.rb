class CreateVoteDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :vote_details do |t|
      t.references :vote, null: false, foreign_key: true
      t.references :choice, null: false, foreign_key: true
      t.integer :status, null: false, default: 2

      t.timestamps
    end
  end
end
